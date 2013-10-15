require 'faker'

FactoryGirl.define do

  factory :mentor_user, class: "User" do
    association :role, factory: :mentor
    sequence(:email) {|n| "mentor_user#{n}@shyne.io" }
    password "password"
    password_confirmation "password"
  end

  factory :mentor do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    headline { Faker::Lorem.sentence(10) }
    experties '{Accounting,Finance}'
    years_of_experience { rand(30) }
    phone_number { Faker::PhoneNumber.phone_number }
    availability { Faker::Lorem.sentence(10) }
    featured { [true, false].sample }
    user
  end
end