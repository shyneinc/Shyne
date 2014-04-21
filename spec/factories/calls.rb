# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :call do
    from_number "17471778437"
    status { CallStatus::Inprogress.new }
    conferencesid "CF0ce8cba9ba6648cc81e61622b1d8ab93"
    sid "CAc391fbdef33c33b5770507fb80b1472b"
    duration { rand(900..1800) }
    call_request
  end
end
