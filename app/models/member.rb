class Member < ActiveRecord::Base
  has_one :user, as: :role, dependent: :nullify
  accepts_nested_attributes_for :user

  has_many :calls

  def display_name
    "#{self.first_name} #{self.last_name}"
  end
end
