class Mentor < ActiveRecord::Base
  has_one :user, as: :role
end
