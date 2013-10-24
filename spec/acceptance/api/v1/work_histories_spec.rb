require 'spec_helper'
require 'rspec_api_documentation/dsl'
include Warden::Test::Helpers

resource 'WorkHistory' do
	header "Accept", "application/vnd.shyne.v1"

	let(:user) { create(:mentor_user) }
	let(:mentor_id){ user.role_id }

	get "/api/mentors/:mentor_id/work_histories" do
    	
		before (:each) do
			login_as user, scope: :user
			create_list(:work_history, 10, mentor_id: mentor_id)
		end

		parameter :mentor_id, "Supply Mentor ID in the url -> /api/mentors/[mentor_id]/work_histories", required: true

		example "Getting all user work history" do
			do_request

			expect(response_body).to eq user.role.work_histories.to_json
			expect(status).to eq 200
		end
	end

	post "/api/mentors/:mentor_id/work_histories" do

		before (:each) do
			login_as user, scope: :user
		end

		parameter :mentor_id, "Mentor" , required: true
		parameter :company, "Company" , required: true , scope: :work
		parameter :title, "Job Title", required: true, scope: :work
		parameter :date_started, "Date Started", required: true, scope: :work
		parameter :date_ended, "Date Ended", required: false, scope: :work
		parameter :current_work, "Current Work?", required: false, scope: :work

		example "Creating mentor's work history" do
			explanation "Once the use is registered as mentor and logged in, create a work history"
			work = attributes_for(:work_history, mentor_id: mentor_id )
			do_request(work: work)
			
			expect(response_body).to be_json_eql work.to_json
			expect(status).to eq 201
		end
  	end

	put "/api/mentors/:mentor_id/work_histories/:id" do
		let(:id){ work_a.id }

		before (:each) do
			login_as user, scope: :user
		end

		parameter :mentor_id, "Mentor" , required: true
		parameter :company, "Company" , required: true , scope: :work
		parameter :title, "Job Title", required: true, scope: :work
		parameter :date_started, "Date Started", required: true, scope: :work
		parameter :date_ended, "Date Ended", required: false, scope: :work
		parameter :current_work, "Current Work?", required: false, scope: :work

    	example "Updating mentor's work history" do
    		explanation "Once the user is signed in and now can update a work_history"
    		work_a = create(:work_history, mentor_id: mentor_id)
    		work_b = attributes_for(:work_history, mentor_id: mentor_id).except(:id)

    		do_request(work: work_b, id: work_a.id)

    		# expect(response_body).to be_json_eql work_b.except(:id).to_json
    		expect(status).to eq 204
    	end
  	end

  	delete "/api/mentors/:mentor_id/work_histories" do
    	example "Deleting mentor's work history" do

    	end
  end
end