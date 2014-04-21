require 'faker'

FactoryGirl.define do

  factory :mentor_user, class: "User" do
    association :role, factory: :mentor
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sequence(:email) { |n| "mentor_user#{n}@shyne.io" }
    password "password"
    password_confirmation "password"
    time_zone { ActiveSupport::TimeZone.us_zones.sample.name }
  end

  factory :mentor do
    headline { Faker::Lorem.sentence(10) }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    linkedin { "www.linkedin.com/in/" + Faker::Lorem.word }
    skills nil
    industries nil
    schools nil
    location nil
    years_of_experience { rand(30) }
    phone_number "15626453725"
    availability { Faker::Lorem.sentence(10) }
    featured { [true, false].sample }
    mentor_status MentorStatus::Applied.new
    status_changed_at nil
    avg_call_duration nil
    avg_rating nil
    total_reviews 0
    user

    factory :mentor_with_reviews do
      after(:create) do |mentor, evaluator|
        create_list(:review, 5, mentor: mentor)
      end
    end

    factory :mentor_with_calls do
      after(:create) do |mentor, evaluator|
        create(:completed_call_request, mentor: mentor)
      end
    end
  end
end