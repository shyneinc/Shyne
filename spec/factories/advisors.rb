require 'faker'

FactoryGirl.define do

  factory :advisor_user, class: "User" do
    association :role, factory: :advisor
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sequence(:email) { |n| "advisor_user#{n}@shyne.io" }
    password "password"
    password_confirmation "password"
    time_zone { ActiveSupport::TimeZone.us_zones.sample.name }
  end

  factory :advisor do
    headline { Faker::Lorem.sentence(10) }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    linkedin { "http://www.linkedin.com/in/" + Faker::Lorem.word }
    skills { Faker::Lorem.word }
    industries { Faker::Lorem.word }
    schools { Faker::Lorem.word }
    location nil
    years_of_experience { rand(30) }
    phone_number "15626453725"
    availability { Faker::Lorem.sentence(10) }
    featured { [true, false].sample }
    advisor_status AdvisorStatus::Applied.new
    status_changed_at nil
    avg_call_duration nil
    avg_rating nil
    total_reviews 0
    user

    factory :advisor_with_reviews do
      after(:create) do |advisor, evaluator|
        create_list(:review, 5, advisor: advisor)
      end
    end

    factory :advisor_with_calls do
      after(:create) do |advisor, evaluator|
        create(:completed_call_request, advisor: advisor)
      end
    end
  end
end