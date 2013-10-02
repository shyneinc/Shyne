FactoryGirl.define do

  factory :member_user, class: "User" do
    association :role, factory: :member

    email Faker::Internet.email
    password "password"
    password_confirmation "password"
  end

  factory :member do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
  end
end