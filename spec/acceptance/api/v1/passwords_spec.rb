require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Password' do
  header "Accept", "application/vnd.shyne.v1"

  let(:user) { create(:user) }

  post "/api/passwords" do
    parameter :email, "Email", :required => true, :scope => :user

    example "Send password reset instructions" do
      do_request(user: user.slice(:email))

      expect(status).to eq 200
      expect(ActionMailer::Base.deliveries.count).to eq 2
    end
  end

  put "/api/passwords" do
    parameter :email, "Email", :required => true, :scope => :user
    parameter :password, "New Password", :required => true, :scope => :user
    parameter :password_confirmation, "Password Confirmation", :required => true, :scope => :user
    parameter :reset_password_token, "Reset Password Token", :required => true, :scope => :user

    example "Reset password" do
      friendly_token = Devise.friendly_token
      user.reset_password_token = Devise.token_generator.digest(User, :reset_password_token, friendly_token)
      user.reset_password_sent_at = DateTime.now
      user.save

      user_attrs = attributes_for(:user, :email => user.email, :reset_password_token => friendly_token).except(:id)

      do_request(user: user_attrs)

      expect(response_body).to be_json_eql({ :reset => true }.to_json)
      expect(status).to eq 200
    end
  end
end