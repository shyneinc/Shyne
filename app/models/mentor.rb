class Mentor < ActiveRecord::Base
  validates :headline, :experties, :years_of_experience, :availability, :phone_number, presence: true
  validates :years_of_experience, :numericality => { :greater_than_or_equal_to => 0 }
  phony_normalize :phone_number, :default_country_code => 'US'
  validates :phone_number, :phony_plausible => true

  has_one :user, as: :role, dependent: :nullify
  accepts_nested_attributes_for :user

  belongs_to :mentor_status

  has_many :calls

  after_update :send_status_email, :if => :mentor_status_id_changed?

  def send_status_email
    if self.mentor_status.title == 'Approved'
      MentorMailer.approval_email(self).deliver
    else self.mentor_status.title == 'Declined'
      MentorMailer.declined_email(self).deliver
    end
  end

  def self.approved
    where(mentor_status_id: MentorStatus.by_status('Approved').id)
  end

  def self.featured
    where(featured: true)
  end

  def self.experties(experties)
    where("? = ANY (experties)", experties)
  end

  def rate_per_minute
    if self.years_of_experience < 2
      1.0
    elsif self.years_of_experience >= 2 && self.years_of_experience <= 7
      2.0
    elsif self.years_of_experience > 7
      3.0
    end
  end

  def full_name
    "#{self.user.first_name} #{self.user.last_name}"
  end
end
