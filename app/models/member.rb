class Member < ActiveRecord::Base
  validates :user, :phone_number, :industries, presence: true
  phony_normalize :phone_number, :default_country_code => 'US'
  validates :phone_number, :phony_plausible => true

  has_one :user, as: :role, dependent: :nullify
  accepts_nested_attributes_for :user
  delegate :full_name, :email, :balanced_customer, :to => :user

  has_many :call_request
  has_many :reviews

  def avatar
    self.user.avatar.thumb.to_s
  end

  def photo_url
    self.user.avatar.url.to_s
  end

  def get_avg_rating
    self.reviews.average('rating').to_f.to_s
  end
end
