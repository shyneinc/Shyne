class Mentor < ActiveRecord::Base
  validates :first_name, :last_name, :headline, :experties, :years_of_experience, :availability, :phone_number, presence: true
  validates :years_of_experience, :numericality => { :greater_than_or_equal_to => 0 }
  phony_normalize :phone_number, :default_country_code => 'US'
  validates :phone_number, :phony_plausible => true

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
