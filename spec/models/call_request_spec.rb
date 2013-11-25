require 'spec_helper'

describe CallRequest do
  it "has a valid factory" do
    expect(build(:call_request)).to be_valid
  end

  let(:call_request) { create(:call_request) }

  describe "ActiveModel validations" do
    context "Basic validations" do
      it { should validate_presence_of :scheduled_at }
      it { should validate_presence_of :mentor }
      it { should validate_presence_of :member }
    end
  end

  describe "ActiveRecord validations" do
    context "Associations" do
      it { expect(call_request).to belong_to(:mentor) }
      it { expect(call_request).to belong_to(:member) }
      it { expect(call_request).to have_many(:calls) }
      it { expect(call_request).to have_many(:payment_transactions) }
    end

    context "Callbacks" do
      it { expect(call_request).to callback(:generate_passcode).after(:validation).on(:create) }
      it { expect(call_request).to callback(:send_status).after(:update) }
      it { expect(call_request).to callback(:calc_mentor_duration).after(:update) }
    end
  end

  describe "Public class methods" do
    context "#calculate_billable_duration" do
      pending
    end

    context "#process_payment" do
      pending
    end

    context "#member_debited?" do
      pending
    end

    context "#mentor_credited?" do
      pending
    end

    context "#debit_amount" do
      pending
    end

    context "#credit_amount" do
      pending
    end

    context "#description" do
      pending
    end
  end
end
