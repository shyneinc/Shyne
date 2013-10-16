require 'faker'

FactoryGirl.define do

  factory :user do
    sequence(:email) {|n| "user#{n}_#{Time.now.to_i}@shyne.io" }
    password "password"
    password_confirmation "password"
  end

end