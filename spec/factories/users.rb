require 'faker'

FactoryGirl.define do

  factory :user do |u|
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sequence(:email) { |n| "user#{n}_#{Time.now.to_i}@shyne.io" }
    password "password"
    password_confirmation "password"
    avatar File.open(File.join(Rails.root, '/public/images/test/spongebob.jpeg'))
    username { "#{first_name}#{last_name}".gsub(/\s+/, "").to_s.downcase }
    slug { "#{first_name}#{last_name}".gsub(/\s+/, "").to_s.downcase }
    time_zone { ActiveSupport::TimeZone.us_zones.sample.name }
    customer_uri nil
    deleted_at nil
  end

end