# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :mentor_status do
    title { ['Applied','Reapplied','Approved','Declined'].sample }
  end
end
