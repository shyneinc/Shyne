require 'faker'

FactoryGirl.define do
  startdate = Date.today - rand(500)

  factory :work_history do
    company { Faker::Company.name }
    title { Faker::Name.title }
    year_started { startdate }
    year_ended { startdate + rand(1000) }
    current_work false
    mentor
  end
end
