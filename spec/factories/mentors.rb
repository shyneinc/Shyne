require 'faker'

FactoryGirl.define do

  factory :mentor_user, class: "User" do
    association :role, factory: :mentor

    sequence(:email) { |n| "user#{n}@shyne.io" }
    password "password"
  end

  factory :mentor do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
  end
end