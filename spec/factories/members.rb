require 'faker'

FactoryGirl.define do

  factory :member do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    user
  end
end