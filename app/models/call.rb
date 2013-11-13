class Call < ActiveRecord::Base
  classy_enum_attr :status, default: :inprogress, enum: :call_status
  validates :sid, :from_number, presence: true

  belongs_to :call_request
  has_many :reviews

  after_update :fetch_duration, :if => :status_changed?

  private

  def fetch_duration
    if self.status.completed? && self.sid

      @client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
      @log = @client.account.calls.get(self.sid.to_s)

      self.duration = @log.duration.to_i
      self.save
    end
  end
  handle_asynchronously :fetch_duration, :run_at => Proc.new { 3.minutes.from_now }

end
