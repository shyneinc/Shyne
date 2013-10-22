require 'faker'

FactoryGirl.define do
	# include ActionDispatch::TestProces

	factory :user do
		first_name { Faker::Name.first_name }
		last_name { Faker::Name.last_name }
	    sequence(:email) {|n| "user#{n}_#{Time.now.to_i}@shyne.io" }
	    password "password"
	    password_confirmation "password"
	    avatar { fixture_file_upload('/public/images/test/spongebob.jpeg' , 'image/png') }
	end

end