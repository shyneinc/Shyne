# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :call do
  	from_number { Faker::PhoneNumber.phone_number.split('x').first }
  	status { CallStatus::Inprogress.new }
  	billed false
  	conferencesid "CF0ce8cba9ba6648cc81e61622b1d8ab93"
  	sid "CAc391fbdef33c33b5770507fb80b1472b"
  	call_request
  end
end
