class Mentor < ActiveRecord::Base
  has_one :user, as: :role
  has_many :experties
  has_many :industries, :through => :experties
  accepts_nested_attributes_for :user

  after_update :send_approval_email, :if => :approved_changed?

  def send_approval_email
    if self.approved?
      MentorMailer.approval_email(self).deliver
    end
  end
end
