FactoryGirl.define do

  factory :member_user, class: "User" do
    association :role, factory: :member

    sequence(:email) { |n| "user#{n}@shyne.io" }
    password "password"
    password_confirmation "password"
  end

  factory :member do
    #attributes for member
  end
end