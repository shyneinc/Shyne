# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :industry do
    title { Faker::Lorem.word }
  end
end
