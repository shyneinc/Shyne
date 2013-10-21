# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :work_history do
    company "MyString"
    date_started "2013-10-21"
    date_ended "2013-10-21"
    current_work false
  end
end
