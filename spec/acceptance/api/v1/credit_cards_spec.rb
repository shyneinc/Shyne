require 'spec_helper'
require 'rspec_api_documentation/dsl'
include Warden::Test::Helpers

resource 'CreditCard' do
  header "Accept", "application/vnd.shyne.v1"

  let(:user) { create(:member_user) }

  before do
    login_as user, scope: :user
    @test_cc = {
        card_number: "4111111111111111",
        expiration_year: 1.years.from_now.year.to_s,
        expiration_month: 1.years.from_now.month.to_s,
        security_code: "123",
        postal_code: "90210"
    }
  end

  get "/api/credit_cards" do
    example_request "Getting all credit cards on file" do
      expect(response_body).to eq user.balanced_customer.cards.find.map(&:attributes).to_json
      expect(status).to eq 200
    end
  end

  post "/api/credit_cards" do
    parameter :card_number, "Credit Card Number", :required => true, :scope => :credit_card
    parameter :expiration_year, "Expiration Year (YYYY)", :required => true, :scope => :credit_card
    parameter :expiration_month, "Expiration Month (MM)", :required => true, :scope => :credit_card
    parameter :security_code, "Security/CVV Code", :required => true, :scope => :credit_card
    parameter :postal_code, "Postal/Zip Code", :required => true, :scope => :credit_card

    example "Add a credit card" do
      explanation "Add a credit card on file for the currently logged-in member"
      do_request(credit_card: @test_cc)

      #TODO: Test response
      expect(status).to eq 201
    end
  end

  delete "/api/credit_cards/:id" do
    before do
      @card = Balanced::Card.new(@test_cc).save
      user.balanced_customer.add_card(@card)
    end

    example "Deleting a credit card" do
      do_request(id: @card.id)
      expect(status).to eq 204
    end
  end
end