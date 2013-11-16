# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :call_request do
    passcode { Random.new.rand(10_000..99_999) }
    status CallRequestStatus::Proposed.new
    scheduled_at { rand(30.days).from_now.to_s(:db) }
    billable_duration nil
    conferencesid nil
    billed nil
    price nil
    member
    mentor
  end
end
