# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Industry.delete_all
industries_json = JSON.parse(open("#{Rails.root}/public/seeds/industries.json").read)
industries_json.each do |industry|
  Industry.create(:title => industry)
end

Admin.create(:email => 'jesal@shyne.io', :password => 'password', :password_confirmation => 'password')
Admin.create(:email => 'rohan@shyne.io', :password => 'password', :password_confirmation => 'password')
Admin.create(:email => 'tim@shyne.io', :password => 'password', :password_confirmation => 'password')

MentorStatus.create([{title: 'Applied'}, {title: 'Reapplied'}, {title: 'Approved'}, {title: 'Declined'}])