class Member < ActiveRecord::Base
  validates :user, :phone_number, presence: true
  phony_normalize :phone_number, :default_country_code => 'US'
  validates :phone_number, :phony_plausible => true

  has_one :user, as: :role, dependent: :nullify
  accepts_nested_attributes_for :user
  delegate :full_name, :email, :balanced_customer, :to => :user

  has_many :call_request
  has_many :reviews
end
