require 'spec_helper'
require 'rspec_api_documentation/dsl'
include Warden::Test::Helpers

resource 'BankAccount' do
  header "Accept", "application/vnd.shyne.v1"

  let(:user) { create(:mentor_user) }

  before do
    login_as user, scope: :user
    @test_ba = {
        name: "Johann Bernoulli",
        account_number: "9900000002",
        routing_number: "021000021",
        type: "Checking"
    }
  end

  get "/api/bank_accounts" do
    example_request "Getting all bank accounts on file" do
      expect(response_body).to eq user.balanced_customer.bank_accounts.find.map(&:attributes).to_json
      expect(status).to eq 200
    end
  end

  post "/api/bank_accounts" do
    parameter :name, "Account Holder's Name", :required => true, :scope => :bank_account
    parameter :account_number, "Account Number", :required => true, :scope => :bank_account
    parameter :routing_number, "Routing Number", :required => true, :scope => :bank_account
    parameter :type, "Checking/Savings", :required => true, :scope => :bank_account

    example "Add a bank account" do
      explanation "Add a bank account on file for the currently logged-in mentor"
      do_request(bank_account: @test_ba)

      #TODO: Test response
      expect(status).to eq 201
    end
  end

  delete "/api/bank_accounts/:id" do
    before do
      @account = Balanced::BankAccount.new(@test_ba).save
      user.balanced_customer.add_bank_account(@account)
    end

    example "Deleting a bank account" do
      do_request(id: @account.id)
      expect(status).to eq 204
    end
  end
end