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

  private

  def generate_passcode
    begin
      tmp_passcode = Random.new.rand(10_000..99_999)
    end while CallRequest.find_by passcode: tmp_passcode
    self.passcode = tmp_passcode
  end
end
