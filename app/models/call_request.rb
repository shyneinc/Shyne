class CallRequest < ActiveRecord::Base
  include Twilio::Sms

  validates :agenda, :status, :scheduled_at, :proposed_duration, :advisor, :member, presence: true

  classy_enum_attr :status, default: :proposed, enum: :call_request_status
  delegate :send_status, to: :status

  belongs_to :member
  belongs_to :advisor
  has_many :calls
  has_many :payment_transactions

  after_validation :generate_passcode, :on => :create
  after_save :send_status, :if => :status_changed?
  after_update :calc_advisor_duration, :if => :billable_duration_changed?

  just_define_datetime_picker :scheduled_at

  default_scope { order('created_at DESC') }

  def calculate_billable_duration
    if self.approved? && self.scheduled_at < (DateTime.now - 1.hour)
      @callers = self.calls.where(status: :completed)
      if @callers.count > 1
        @call_durations = Hash.new

        @callers.find_each do |call|
          if @call_durations.has_key?(call.from_number)
            @call_durations[call.from_number] += call.duration.to_i
          else
            @call_durations[call.from_number] = call.duration.to_i
          end
        end

        self.billable_duration = @call_durations.values.min
        self.status = :completed
        self.save
      end
    end
  end

  def process_payment
    if self.completed? && self.billable_duration > 0
      if !self.member_debited?
        begin
          debit = self.member.balanced_customer.debit(
            :amount => self.debit_amount,
            :description => self.description,
            :appears_on_statement_as => "Shyne - #{self.advisor.full_name}",
            :on_behalf_of => self.advisor.balanced_customer,
            :meta => {
                :call_request_id => self.id
            }
          )
          self.payment_transactions.create(type: debit._type, amount: debit.amount/100, status: debit.status, uri: debit.uri)
          self.status = :processed_member
          CallRequestMailer.delay.send_call_receipt_to_member(self)
        rescue => e
          #Log Error
          NewRelic::Agent.notice_error(e, {})
        end
      end

      if self.member_debited? && !self.advisor_credited?
        if self.advisor.balanced_customer.bank_accounts.any?
          begin
            credit = self.advisor.balanced_customer.credit(
              :amount => self.credit_amount,
              :description => self.description,
              :appears_on_statement_as => "Shyne - #{self.member.full_name}",
              :meta => {
                  :call_request_id => self.id
              }
            )
            self.payment_transactions.create(type: credit._type, amount: credit.amount/100, status: credit.status, uri: credit.uri)
            self.status = :processed_advisor
            CallRequestMailer.delay.send_call_income_to_advisor(self)
          rescue => e
            #Log Error
            NewRelic::Agent.notice_error(e, {})
          end
        end
      end

      if self.member_debited? && self.advisor_credited?
        self.status = :processed
      end

      self.save
    end
  end

  def member_debited?
    ["succeeded"].include? self.payment_transactions.where(type: "debit").order(created_at: :desc).limit(1).pluck(:status).first
  end

  def advisor_credited?
    ["paid", "pending"].include? self.payment_transactions.where(type: "credit").order(created_at: :desc).limit(1).pluck(:status).first
  end

  def approved?
    self.status.approved_advisor? || self.status.approved_member?
  end

  def completed?
    self.status.completed? || self.status.processed_member? || self.status.processed_advisor?
  end

  def debit_amount
    rate_in_cents = self.advisor.rate_per_minute * 100
    duration_in_mins = self.billable_duration.to_f/60
    rate_in_cents * duration_in_mins.round
  end

  def shyne_commission
    debit_amount * 0.3
  end

  def credit_amount
    debit_amount - shyne_commission
  end

  def estimated_debit_amount
    rate_in_cents = self.advisor.rate_per_minute * 100
    duration_in_mins = self.proposed_duration
    rate_in_cents * duration_in_mins
  end

  def description
    "Call# #{self.id} with #{self.member.full_name} & #{self.advisor.full_name}"
  end

  def twilio_number
    ENV['TWILIO_NUMBER']
  end

  def scheduled_date #TODO: Change this to scheduled_date_advisor
    date = self.scheduled_at.in_time_zone(self.advisor.user.time_zone)
    date.strftime("%A, %B #{date.day.ordinalize}, at %I:%M%p")
  end

  def scheduled_date_member
    date = self.scheduled_at.in_time_zone(self.member.user.time_zone)
    date.strftime("%A, %B #{date.day.ordinalize}, at %I:%M%p")
  end

  def scheduled_date_short #TODO: Change this to scheduled_date_short_advisor
    date = self.scheduled_at.in_time_zone(self.advisor.user.time_zone)
    date.strftime("%I:%M%p on %A, #{date.day.ordinalize}")
  end

  def scheduled_date_short_member
    date = self.scheduled_at.in_time_zone(self.member.user.time_zone)
    date.strftime("%I:%M%p on %A, #{date.day.ordinalize}")
  end

  def conversation_id
    conversation = Conversation.where("subject LIKE '%?%'", self.id)
    conversation.first.id if conversation.present?
  end

  private
  def generate_passcode
    begin
      tmp_passcode = Random.new.rand(10_000..99_999)
    end while CallRequest.find_by passcode: tmp_passcode
    self.passcode = tmp_passcode
  end

  def calc_advisor_duration
    self.advisor.calc_avg_duration
  end
end
