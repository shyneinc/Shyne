require 'faker'

FactoryGirl.define do
  startdate = Date.today - rand(500)
  
  factory :work_history do
    company { Faker::Company.name }
    date_started { startdate }
    date_ended { startdate + rand(1000) }
    current_work false
  end
end
