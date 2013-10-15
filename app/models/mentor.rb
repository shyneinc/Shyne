class Mentor < ActiveRecord::Base
  has_one :user, as: :role, dependent: :nullify
  accepts_nested_attributes_for :user

  belongs_to :mentor_status

  has_many :experty
  has_many :industries, :through => :experty

  has_many :calls

  after_update :send_status_email, :if => :mentor_status_id_changed?

  def send_status_email
    if self.mentor_status.title == 'Approved'
      MentorMailer.approval_email(self).deliver
    else self.mentor_status.title == 'Declined'
      MentorMailer.declined_email(self).deliver
    end
  end

  def self.featured
    where(featured: true).to_a
  end

  def self.experties(experties)
    where("? = ANY (experties)", experties).to_a
  end

  def display_name
    "#{self.first_name} #{self.last_name}"
  end
end
