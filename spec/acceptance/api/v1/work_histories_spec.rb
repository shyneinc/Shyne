require 'spec_helper'
require 'rspec_api_documentation/dsl'
include Warden::Test::Helpers

resource 'WorkHistory' do
  header "Accept", "application/vnd.shyne.v1"

  let(:user) { create(:mentor_user) }
  let(:mentor_id) { user.role_id }

  get "/api/mentors/:mentor_id/work_histories" do

    before (:each) do
      login_as user, scope: :user
      create_list(:work_history, 10, mentor_id: mentor_id)
    end

    parameter :mentor_id, "Mentor ID", required: true

    example "Getting mentor's work history" do
      do_request

      #TODO: Fix using factory_girl_json
      #expect(response_body).to eq user.role.work_histories.to_json
      expect(status).to eq 200
    end
  end

  post "/api/mentors/:mentor_id/work_histories" do

    before (:each) do
      login_as user, scope: :user
    end

    parameter :mentor_id, "Mentor ID", required: true
    parameter :company, "Company", required: true, scope: :work
    parameter :title, "Job Title", required: true, scope: :work
    parameter :date_started, "Date Started", required: true, scope: :work
    parameter :date_ended, "Date Ended", required: false, scope: :work
    parameter :current_work, "Current Work?", required: false, scope: :work

    example "Creating mentor's work history" do
      explanation "Once the user is registered as mentor and logged in, they can add their work history"
      work = attributes_for(:work_history, mentor_id: mentor_id)
      do_request(work_history: work)

      #TODO: Fix using factory_girl_json
      #expect(response_body).to be_json_eql work.to_json
      expect(status).to eq 201
    end
  end

  put "/api/mentors/:mentor_id/work_histories/:id" do

    before do
      login_as user, scope: :user
    end

    parameter :mentor_id, "Mentor ID", required: true
    parameter :id, "Work History ID", required: true
    parameter :company, "Company", required: true, scope: :work
    parameter :title, "Job Title", required: true, scope: :work
    parameter :date_started, "Date Started", required: true, scope: :work
    parameter :date_ended, "Date Ended", required: false, scope: :work
    parameter :current_work, "Current Work?", required: false, scope: :work

    example "Updating mentor's work history" do
      work_a = create(:work_history, mentor_id: mentor_id)
      work_b = attributes_for(:work_history, mentor_id: mentor_id).except(:id)

      do_request(work_history: work_b, id: work_a.id)

      # expect(response_body).to be_json_eql work_b.except(:id).to_json
      expect(status).to eq 204
    end
  end

  delete "/api/mentors/:mentor_id/work_histories/:id" do

    before do
      login_as user, scope: :user
    end

    parameter :mentor_id, "Mentor ID", required: true
    parameter :id, "Work History ID", required: true

    example "Deleting mentor's work history" do
      work = create(:work_history, mentor_id: mentor_id)
      do_request(id: work.id)

      expect(status).to eq 204
    end
  end
end