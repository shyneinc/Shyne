# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :call_request do
    passcode { Random.new.rand(10_000..99_999) }
    status CallRequestStatus::Proposed.new
    scheduled_at { rand(30.days).from_now.to_s(:db) }
    billable_duration nil
    member
    mentor

    factory :approved_call_request, :parent => :call_request do |call_request|
      status CallRequestStatus::Approved.new
      scheduled_at 2.hours.ago
      calls {
        [build(:call, status: CallStatus::Completed.new, duration: 60, from_number: "19496665341"),
         build(:call, status: CallStatus::Completed.new, duration: 900, from_number: "19496665341"),
         build(:call, status: CallStatus::Completed.new, duration: 1000, from_number: "17471778437")]
      }
    end

    factory :completed_call_request, :parent => :call_request do |call_request|
      status CallRequestStatus::Completed.new
      billable_duration 960
      scheduled_at 2.hours.ago
      calls {
        [build(:call, status: CallStatus::Completed.new, duration: 60, from_number: "19496665341"),
         build(:call, status: CallStatus::Completed.new, duration: 900, from_number: "19496665341"),
         build(:call, status: CallStatus::Completed.new, duration: 1000, from_number: "17471778437")]
      }
    end
  end
end
