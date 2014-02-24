require 'spec_helper'
require 'rspec_api_documentation/dsl'
include Warden::Test::Helpers

resource 'CallRequest' do
  header "Accept", "application/vnd.shyne.v1"

  let(:user) { create(:member_user) }
  let(:mentor) { create(:mentor) }
  let!(:call_request) { create(:call_request, member: user.role) }

  before do
    login_as user, scope: :user
    user.stub_chain(:balanced_customer, :bank_accounts, :any?).and_return(true)
    user.stub_chain(:balanced_customer, :cards, :any?).and_return(true)
  end

  get "/api/call_requests" do
    example_request "Getting all call requests" do
      role = user.role_type.downcase
      expect(response_body).to be_json_eql CallRequest.where("#{role}_id" => current_user.role_id).to_json({:include =>
                                                                                                                {:mentor =>
                                                                                                                     {:methods => [:full_name, :rate_per_minute, :phone_number, :avg_call_duration, :get_avg_rating]},
                                                                                                                 :member => {:methods => [:full_name, :phone_number]}
                                                                                                                }, :methods => [:scheduled_date]})
      expect(status).to eq 200
    end
  end

  get '/api/call_requests/:id' do
    pending
  end

  post "/api/call_requests" do
    parameter :agenda, "Agenda/Focus of the Call", :required => true, :scope => :call_request
    parameter :member_id, "Member ID", :required => true, :scope => :call_request
    parameter :mentor_id, "Mentor ID", :required => true, :scope => :call_request
    parameter :scheduled_at, "Scheduled At", :required => true, :scope => :call_request
    parameter :proposed_duration, "Proposed duration time", :required => true, :scope => :call_request

    example "Creating a call request" do
      explanation "Once the member is authenticated and has a CC on file, they can propose or change a call request"
      call_request = attributes_for(:call_request, member: user.role).except(:id, :passcode)
      call_request[:member_id] = user.role.id
      call_request[:mentor_id] = mentor.id

      do_request(call_request: call_request)

      hash = JSON.parse(response_body)
      hash['scheduled_at'] = DateTime.parse(hash['scheduled_at']).to_s(:db)
      hash.delete('passcode')

      expect(hash.to_json).to be_json_eql(call_request.to_json)
      expect(status).to eq 201
      #TODO: Test mailers
    end
  end

  put "/api/call_requests/:id" do
    parameter :id, "Call Request ID", required: true
    parameter :member_id, "Member ID", :required => true, :scope => :call_request
    parameter :mentor_id, "Mentor ID", :required => true, :scope => :call_request
    parameter :scheduled_at, "Scheduled At", :required => true, :scope => :call_request
    parameter :request_status, "Status (Proposed (default), Approved, Changed)", :required => false, :scope => :call_request

    let(:id) { call_request.id }

    example "Updating a call request" do
      explanation "Once the mentor/member is authenticated and has a bank account/credit card on file, they can approve or change a call request"
      call_request = attributes_for(:call_request, :status => CallRequestStatus::Approved.new)
      do_request(call_request: call_request)

      expect(status).to eq 204
    end
  end

  delete "/api/call_requests/:id" do
    example "Deleting a call request" do
      do_request(id: call_request.id)
      expect(status).to eq 204
    end
  end
end