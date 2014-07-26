class Mentor < ActiveRecord::Base
  classy_enum_attr :mentor_status, default: :applied

  validates :user, :headline, :city, :state, :years_of_experience, :availability, :phone_number, :industries, :schools, :skills, presence: true
  validates :years_of_experience, :numericality => {:greater_than_or_equal_to => 0}
  validates :headline, length: {maximum: 280}, allow_blank: false
#   validates :linkedin, :format => { :with => /(^$)|(^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix,
#                                     :message => "Please enter the address of your LinkedIn profile (e.g. www.linkedin.com/in/johnsmith)"}

  validates_format_of :linkedin, :with => URI::regexp(%w(http https)),
                                  :message => "Please enter the address of your LinkedIn profile (e.g. www.linkedin.com/in/johnsmith)"

  phony_normalize :phone_number, :default_country_code => 'US'
  validates :phone_number, :phony_plausible => true

  validates :phone_number, :presence => true, :length => { :maximum => 11, :minimum => 11, :message => "Please enter a 11-digit phone number"}

  has_one :user, as: :role, dependent: :nullify
  accepts_nested_attributes_for :user
  delegate :full_name, :email, :balanced_customer, :full_address, :to => :user

  has_many :call_requests, after_add: :calc_avg_duration, after_remove: :calc_avg_duration
  has_many :reviews, after_add: :calc_avg_rating, after_remove: :calc_avg_rating
  has_many :work_histories

  include PgSearch
  multisearchable :against => [:full_name, :headline, :location, :skills, :industries, :schools, :worked_at, :position],
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

  scope :approved, -> { where(mentor_status: :approved) }
  scope :featured, -> { where(featured: true) }
  scope :skills, ->(skill) { where("skills like ?", "%#{skill}%") }
  scope :industries, ->(industry) { where("industries like ?", "%#{industry}%") }
  scope :schools, ->(school) { where("schools like ?", "%#{school}%") }
  scope :not_deleted, lambda { self.joins("join users on users.id = mentors.user_id").where('users.deleted_at IS NULL') }

  def rate_per_minute
    if self.years_of_experience < 2
      1
    elsif self.years_of_experience >= 2 && self.years_of_experience <= 7
      2
    elsif self.years_of_experience > 7
      3
    end
  end

  def avatar
    self.user.avatar.thumb.to_s
  end

  def photo_url
    self.user.avatar.url.to_s
  end

  def worked_at
    self.work_histories.map(&:company).join(" ")
  end

  def approved?
    self.mentor_status.approved?
  end

  def calc_avg_rating
    avg_rating = self.reviews.average('rating').to_f
    self.update_attribute(:avg_rating, avg_rating)
  end
  handle_asynchronously :calc_avg_rating, :priority => 10

  def calc_avg_duration
    avg_call_duration = self.call_requests.average('billable_duration').to_f
    self.update_attribute(:avg_call_duration, avg_call_duration)
  end
  handle_asynchronously :calc_avg_duration, :priority => 10

  def get_avg_rating
    self.reviews.average('rating').to_f.to_s
  end

  def currently_working_at
    self.work_histories.where(:current_work => true).map! { |p| "#{p.title} at #{p.company}" }.first
  end

  def previously_worked_at
    self.work_histories.where(:current_work => false).map! { |p| "#{p.title} at #{p.company}" }.first
  end

  def position
    self.work_histories.map(&:title).join(" ")
  end

  def previous_companies
    self.work_histories.where(:current_work => false).map(&:company).join(", ")
  end

  def current_position
    self.work_histories.where(:current_work => true).map(&:title).first
  end

  def current_company
    self.work_histories.where(:current_work => true).map(&:company).first
  end

  def full_address
    [self.city, self.state].join(", ")
  end

  def total_calls
    self.call_requests.where(status: [:completed, :processed_member, :processed_mentor, :processed]).size
  end

  def total_reviews
    self.reviews.size
  end
end
