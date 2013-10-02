class Mentor < ActiveRecord::Base
  has_one :user, as: :role
  has_many :experties
  has_many :industries, :through => :experties
  accepts_nested_attributes_for :user
end
