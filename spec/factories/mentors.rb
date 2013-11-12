require 'faker'

FactoryGirl.define do

  factory :mentor_user, class: "User" do
    association :role, factory: :mentor
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sequence(:email) { |n| "mentor_user#{n}@shyne.io" }
    password "password"
    password_confirmation "password"
  end

  factory :mentor do
    headline { Faker::Lorem.sentence(10) }
    location { "#{Faker::Address.city}, #{Faker::Address.state_abbr}" }
    linkedin { "http://linkedin.com/" + Faker::Lorem.word }
    experties { ['{Accounting,Finance}', '{Banking}', '{Legal Services}', '{Internet,E-learning}'].sample }
    years_of_experience { rand(30) }
    phone_number { Faker::PhoneNumber.phone_number.split('x').first }
    availability { Faker::Lorem.sentence(10) }
    featured { [true, false].sample }
    mentor_status MentorStatus::Applied.new
    status_changed_at nil
    user
  end
end