require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'WorkHistory' do
	header "Accept", "application/vnd.shyne.v1"

	let(:user) { create(:user) }
	let(:mentor) { create(:mentor) }

	get "/api/mentors/:mentor_id/work_histories" do
		let(:mentor_id){ mentor.id }

		include Warden::Test::Helpers

		before (:each) do
			login_as user, scope: :user
			mentor.user = user
			create_list(:work_history, 10, mentor: mentor)
		end

		example "Fetch all user work history" do
			do_request

			hash = JSON.parse(response_body)

			expect(hash.count).to eq 10
			expect(status).to eq 200
		end
	end

	post "/api/mentors/:mentor_id/work_histories" do
		example "Creating a work history" do
			
		end
	end
end