require 'faker'

FactoryGirl.define do
  startdate = Date.today - rand(500)

  factory :work_history do
    company { Faker::Company.name }
    title { Faker::Name.title }
    date_started { startdate.strftime("%B %Y") }
    date_ended { startdate + rand(1000) }
    current_work false
    advisor
  end
end
