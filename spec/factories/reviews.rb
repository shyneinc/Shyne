# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :review do
    review { Faker::Lorem.sentence(10) }
    rating { rand(0..5).ceil.round(1).to_s }
    advisor
    member
    call
  end
end
