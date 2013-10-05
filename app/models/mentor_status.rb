class MentorStatus < ActiveRecord::Base
  has_many :mentor

  def self.by_status(status)
    where(title: status).first
  end
end
