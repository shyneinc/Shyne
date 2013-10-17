require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'User' do
  header "Accept", "application/vnd.shyne.v1"

  post "/api/users" do
    parameter :email, "First name", :required => true, :scope => :user
    parameter :password, "Last name", :required => true, :scope => :user
    parameter :password_confirmation, "Last name", :required => true, :scope => :user

    example "Registering a user" do
      user = FactoryGirl.attributes_for(:user).except(:id)
      do_request(user: user)

      hash = JSON.parse(response_body)
      hash.delete('role_id')
      hash.delete('role_type')

      hash.to_json.should be_json_eql(user.except(:password, :password_confirmation).to_json)

      expect(status).to eq 201
    end
  end

  put "/api/users" do
    include Warden::Test::Helpers

    before do
      user = FactoryGirl.create(:user)
      login_as user, scope: :user
    end

    parameter :email, "First name", :required => true, :scope => :user
    parameter :password, "Last name", :required => true, :scope => :user
    parameter :password_confirmation, "Last name", :required => true, :scope => :user

    example "Updating a user" do
      user_attrs = FactoryGirl.attributes_for(:user).except(:id)
      do_request(user: user_attrs)

      expect(status).to eq 204
    end
  end
end