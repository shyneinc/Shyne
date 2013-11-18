class CallRequest < ActiveRecord::Base
  validates :status, :scheduled_at, :mentor, :member, presence: true

  classy_enum_attr :status, default: :proposed, enum: :call_request_status

  belongs_to :member
  belongs_to :mentor
  has_many :calls

  after_validation :generate_passcode, :on => :create
  after_update :send_status, :if => :status_changed?

  just_define_datetime_picker :scheduled_at

  #delegated into the enum class
  delegate :send_status, to: :status

  def calculate_billable_duration
    if self.status.approved? && self.scheduled_at < (DateTime.now - 1.hour)
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
        self.passcode = -1 if self.billable_duration > 0
        if self.save
          CallRequestMailer.delay.send_duration(self)
        end
      end
    end
  end

  def generate_passcode
    begin
      tmp_passcode = Random.new.rand(10_000..99_999)
    end while CallRequest.find_by passcode: tmp_passcode
    self.passcode = tmp_passcode
  end
end
