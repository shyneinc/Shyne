# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :experty, :class => 'Experties' do
    mentor ""
    industry ""
  end
end
