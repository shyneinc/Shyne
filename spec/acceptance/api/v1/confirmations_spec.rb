require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Confirmation' do
  header "Accept", "application/vnd.shyne.v1"

  let(:user) { create(:user) }

  get "/api/confirmations" do
    include Warden::Test::Helpers
    parameter :confirmation_token, "Confirm user", :required => true

    let(:confirmation_token) { Devise.friendly_token }

    before (:each) do
      user.confirmation_token = Devise.token_generator.digest(User, :confirmation_token, confirmation_token)
      user.save
    end

    example_request "Confirm user" do
      expect(response_body).to be_json_eql({:confirmed => true}.to_json)
      expect(status).to eq 200
    end
  end

  post "/api/confirmations" do
    include Warden::Test::Helpers

    before (:each) do
      login_as user, scope: :user
    end

    example_request "Resend confirmation email" do
      expect(status).to eq 200
      expect(ActionMailer::Base.deliveries.count).to eq 2
    end
  end
end