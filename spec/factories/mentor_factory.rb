FactoryGirl.define do

  factory :mentor_user, class: "User" do
    association :role, factory: :mentor

    sequence(:email) { |n| "user#{n}@shyne.io" }
    password "password"
    password_confirmation "password"
  end

  factory :mentor do
    #attributes for mentor
  end
end