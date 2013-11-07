require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'User' do
  header "Accept", "application/vnd.shyne.v1"

  let(:user) { create(:user) }

  get "/api/users" do
    include Warden::Test::Helpers

    before (:each) do
      login_as user, scope: :user
    end

    example_request "Show current user" do
      expect(response_body).to be_json_eql({:info => "Current User",
                                            :user => user,
                                            :confirmed => user.confirmed?
                                           }.to_json)
      expect(status).to eq 200
    end
  end

  post "/api/users" do
    parameter :first_name, "First name", :required => true, :scope => :user
    parameter :last_name, "Last name", :required => true, :scope => :user
    parameter :avatar, "Avatar", :required => false, :scope => :user
    parameter :email, "Email", :required => true, :scope => :user
    parameter :password, "Password", :required => true, :scope => :user
    parameter :password_confirmation, "Password Confirmation", :required => true, :scope => :user
    parameter :time_zone, "Time Zone", :required => false, :scope => :user

    example "Registering a user" do
      user = attributes_for(:user).except(:id)
      do_request(user: user)

      hash = JSON.parse(response_body)
      hash.delete('role_id')
      hash.delete('role_type')
      hash.delete('avatar')

      hash.to_json.should be_json_eql(user.except(:password, :password_confirmation, :avatar).to_json)

      expect(status).to eq 201
      expect(ActionMailer::Base.deliveries.count).to eq 1
    end
  end

  put "/api/users" do
    include Warden::Test::Helpers

    before do
      login_as user, scope: :user
    end

    parameter :first_name, "First name", :required => true, :scope => :user
    parameter :last_name, "Last name", :required => true, :scope => :user
    parameter :avatar, "Avatar", :required => false, :scope => :user
    parameter :email, "Email", :required => true, :scope => :user
    parameter :password, "Password", :required => true, :scope => :user
    parameter :password_confirmation, "Password Confirmation", :required => true, :scope => :user
    parameter :time_zone, "Time Zone", :required => false, :scope => :user

    example "Updating a user" do
      user_attrs = attributes_for(:user).except(:id)
      do_request(user: user_attrs)

      expect(status).to eq 204
    end
  end
end