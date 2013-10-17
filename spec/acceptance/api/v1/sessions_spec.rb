require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Session' do
  header "Accept", "application/vnd.shyne.v1"

  let!(:user) { User.create(FactoryGirl.attributes_for(:user)) }

  post "/api/login" do
    parameter :email, "Email", :required => true, :scope => :user
    parameter :password, "Password", :required => true, :scope => :user

    let(:email) { user.email }
    let(:password) { user.password }

    example_request "Logging in" do
      expect(response_body).to be_json_eql({ :success => true,
                                         :info => "Logged in",
                                         :user => user
                                       }.to_json)
      expect(status).to eq 200
    end
  end

  post "/api/logout" do
    include Warden::Test::Helpers

    before (:each) do
      login_as user, scope: :user
    end

    example_request "Logging out" do
      expect(response_body).to be_json_eql({ :success => true,
                                         :info => "Logged out"
                                       }.to_json)
      expect(status).to eq 200
    end
  end

  get "/api/current_user" do
    include Warden::Test::Helpers

    before (:each) do
      login_as user, scope: :user
    end

    example_request "Show current user" do
      expect(response_body).to be_json_eql({ :success => true,
                                         :info => "Current User",
                                         :user => user
                                       }.to_json)
      expect(status).to eq 200
    end
  end
end