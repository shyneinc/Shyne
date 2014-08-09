require 'spec_helper'
require 'rspec_api_documentation/dsl'
include Warden::Test::Helpers

resource 'WorkHistory' do
  header "Accept", "application/vnd.shyne.v1"

  let(:user) { create(:advisor_user) }
  let(:advisor_id) { user.role_id }

  get "/api/advisors/:advisor_id/work_histories" do

    before (:each) do
      login_as user, scope: :user
      create_list(:work_history, 10, advisor_id: advisor_id)
    end

    parameter :advisor_id, "Advisor ID", required: true

    example "Getting advisor's work history" do
      do_request

      expect(response_body).to eq user.role.work_histories.to_json(:only => [:id, :advisor_id, :current_work, :title, :company, :date_started, :date_ended],
                                                                           :methods => [:started_month, :started_year, :ended_month, :ended_year])
      expect(status).to eq 200
    end
  end

  post "/api/advisors/:advisor_id/work_histories" do

    before (:each) do
      login_as user, scope: :user
    end

    parameter :advisor_id, "Advisor ID", required: true
    parameter :company, "Company", required: true, scope: :work
    parameter :title, "Job Title", required: true, scope: :work
    parameter :date_started, "Date Started", required: true, scope: :work
    parameter :date_ended, "Date Ended", required: false, scope: :work
    parameter :current_work, "Current Work?", required: false, scope: :work

    example "Creating advisor's work history" do
      explanation "Once the user is registered as advisor and logged in, they can add their work history"
      work = attributes_for(:work_history, advisor_id: advisor_id)
      do_request(work_history: work)

      expect(response_body).to be_json_eql work.to_json(:only => [:id, :advisor_id, :current_work, :title, :company, :date_started, :date_ended],
                                                        :methods => [:started_month, :started_year, :ended_month, :ended_year])
      expect(status).to eq 201
    end
  end

  put "/api/advisors/:advisor_id/work_histories/:id" do

    before do
      login_as user, scope: :user
    end

    parameter :advisor_id, "Advisor ID", required: true
    parameter :id, "Work History ID", required: true
    parameter :company, "Company", required: true, scope: :work
    parameter :title, "Job Title", required: true, scope: :work
    parameter :date_started, "Date Started", required: true, scope: :work
    parameter :date_ended, "Date Ended", required: false, scope: :work
    parameter :current_work, "Current Work?", required: false, scope: :work

    example "Updating advisor's work history" do
      work_a = create(:work_history, advisor_id: advisor_id)
      work_b = attributes_for(:work_history, advisor_id: advisor_id).except(:id)

      do_request(work_history: work_b, id: work_a.id)

      # expect(response_body).to be_json_eql work_b.except(:id).to_json
      expect(status).to eq 204
    end
  end

  delete "/api/advisors/:advisor_id/work_histories/:id" do

    before do
      login_as user, scope: :user
    end

    parameter :advisor_id, "Advisor ID", required: true
    parameter :id, "Work History ID", required: true

    example "Deleting advisor's work history" do
      work = create(:work_history, advisor_id: advisor_id)
      do_request(id: work.id)

      expect(status).to eq 204
    end
  end
end