require 'faker'

FactoryGirl.define do

  factory :mentor do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    headline { Faker::Lorem.sentence(10) }
    years_of_experience { rand(30) }
    phone_number { Faker::PhoneNumber.phone_number }
    availability { Faker::Lorem.sentence(10) }
    featured { [true, false].sample }
    user
  end
end