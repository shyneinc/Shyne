FactoryGirl.define do

  factory :user do
    sequence(:email) { |n| "user#{n}@shyne.io" }
    password "password"
    password_confirmation "password"
  end

end