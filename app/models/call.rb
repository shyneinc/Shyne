class Call < ActiveRecord::Base
  classy_enum_attr :status, default: :inprogress, enum: :call_status
  validates :sid, :from_number, presence: true

  belongs_to :call_request
  has_many :reviews

  after_update :fetch_duration, :if => :status_changed?
  delegate :fetch_duration, to: :status
end
