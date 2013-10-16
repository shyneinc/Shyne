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
    experties { ['{Accounting,Finance}','{Banking}','{Legal Services}','{Internet,E-learning}'].sample }
    years_of_experience { rand(30) }
    phone_number { (rand(899) + 100).to_s + "-" + (rand(899) + 100).to_s + "-" + (rand(8999) + 1000).to_s }
    availability { Faker::Lorem.sentence(10) }
    featured { [true, false].sample }
    mentor_status_id { MentorStatus.by_status('Applied').id }
    status_changed_at nil
    user
  end
end