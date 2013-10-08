class Member < ActiveRecord::Base
  has_one :user, as: :role
  accepts_nested_attributes_for :user

  has_many :calls
end
