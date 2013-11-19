class Mentor < ActiveRecord::Base
  classy_enum_attr :mentor_status, default: :applied

  validates :user, :headline, :location, :experties, :years_of_experience, :availability, :phone_number, presence: true
  validates :years_of_experience, :numericality => {:greater_than_or_equal_to => 0}
  phony_normalize :phone_number, :default_country_code => 'US'
  validates :phone_number, :phony_plausible => true

  has_one :user, as: :role, dependent: :nullify
  accepts_nested_attributes_for :user

  has_many :call_requests, after_add: :get_avg_duration, after_remove: :get_avg_duration
  has_many :reviews, after_add: :get_avg_rating, after_remove: :get_avg_rating
  has_many :work_histories
 

  include PgSearch
  multisearchable :against => [:full_name, :headline, :location, :experties, :worked_at],
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
    self.user.full_name
  end

  def email
    self.user.email
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

  def get_avg_rating( review )
    avg_rating = self.reviews.average('rating').to_f
    self.update_attribute(:avg_rating, avg_rating )
  end

  def get_avg_duration( call_request )
    avg_call_duration = self.call_requests.average('billable_duration').to_f
    self.update_attribute(:avg_call_duration, avg_call_duration )
  end
end
