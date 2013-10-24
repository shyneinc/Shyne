require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'WorkHistory' do
	header "Accept", "application/vnd.shyne.v1"

	let(:user) { create(:mentor_user) }

	get "/api/mentors/:mentor_id/work_histories" do
    include Warden::Test::Helpers

    let(:mentor_id){ user.role_id }

		before (:each) do
			login_as user, scope: :user
			create_list(:work_history, 10, mentor_id: mentor_id)
		end

		example "Getting mentor's work history" do
			do_request

			expect(response_body).to eq user.role.work_histories.to_json
			expect(status).to eq 200
		end
	end

	post "/api/mentors/:mentor_id/work_histories" do
		example "Creating mentor's work history" do
			
		end
  end

  put "/api/mentors/:mentor_id/work_histories" do
    example "Updating mentor's work history" do

    end
  end

  delete "/api/mentors/:mentor_id/work_histories" do
    example "Deleting mentor's work history" do

    end
  end
end