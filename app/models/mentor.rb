class Mentor < ActiveRecord::Base
  classy_enum_attr :mentor_status, default: :applied

  validates :user, :headline, :experties, :years_of_experience, :availability, :phone_number, presence: true
  validates :years_of_experience, :numericality => {:greater_than_or_equal_to => 0}
  phony_normalize :phone_number, :default_country_code => 'US'
  validates :phone_number, :phony_plausible => true

  has_one :user, as: :role, dependent: :nullify
  accepts_nested_attributes_for :user

  has_many :call_request
  has_many :work_histories
  has_many :reviews

  include PgSearch
  multisearchable :against => [:full_name, :headline, :experties, :worked_at],
                  ignoring: :accents,
                  :if => :approved?

  after_update :send_status_email, :if => :mentor_status_changed?

  def send_status_email
    if self.mentor_status.approved?
      MentorMailer.approval_email(self).deliver
    elsif self.mentor_status.declined?
      MentorMailer.declined_email(self).deliver
    end
  end

  def self.approved
    where(mentor_status: :approved)
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

  def avatar
    self.user.avatar.thumb.to_s
  end

  def worked_at
    self.work_histories.map(&:company).join(" ")
  end

  def approved?
    self.mentor_status.approved?
  end
end
