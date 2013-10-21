require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Session' do
  header "Accept", "application/vnd.shyne.v1"

  let!(:user) { create(:user) }

  post "/api/sessions" do
    parameter :email, "Email", :required => true, :scope => :user
    parameter :password, "Password", :required => true, :scope => :user

    let(:email) { user.email }
    let(:password) { user.password }

    example_request "Logging in" do
      expect(response_body).to be_json_eql({ :info => "Logged in",
                                         :user => user
                                       }.to_json)
      expect(status).to eq 200
    end
  end

  delete "/api/sessions" do
    include Warden::Test::Helpers

    before (:each) do
      login_as user, scope: :user
    end

    example_request "Logging out" do
      expect(response_body).to be_json_eql({ :info => "Logged out"
                                       }.to_json)
      expect(status).to eq 200
    end
  end
end