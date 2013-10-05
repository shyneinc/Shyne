class Mentor < ActiveRecord::Base
  has_one :user, as: :role
  belongs_to :mentor_status
  has_many :experty
  has_many :industries, :through => :experty
  accepts_nested_attributes_for :user

  after_update :send_status_email, :if => :mentor_status_id_changed?

  def send_status_email
    if self.mentor_status.title == 'Approved'
      MentorMailer.approval_email(self).deliver
    else self.mentor_status.title == 'Declined'
      MentorMailer.declined_email(self).deliver
    end
  end
end
