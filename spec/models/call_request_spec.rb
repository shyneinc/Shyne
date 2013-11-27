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
      let(:approved_call_request) { create(:approved_call_request) }

      before(:all) do
        approved_call_request.calculate_billable_duration
      end

      it "calculates the correct billable duration" do
        expect(approved_call_request.billable_duration).to eq 960
      end

      it "sets the status to completed" do
        expect(approved_call_request.status).to eq :completed
      end
    end

    context "#process_payment" do
      let(:completed_call_request) { create(:completed_call_request) }

      before(:all) do
        mock_debit = OpenStruct.new({"_type" => "debit", "amount" => 100, "status" => "succeeded", "uri" => "test"})
        mock_credit = OpenStruct.new({"_type" => "credit", "amount" => 70, "status" => "succeeded", "uri" => "test"})
        completed_call_request.member.stub_chain(:balanced_customer, :debit).and_return(mock_debit)
        completed_call_request.mentor.stub_chain(:balanced_customer, :credit).and_return(mock_credit)

        completed_call_request.process_payment
      end

      it "debits the member" do
        expect(completed_call_request.member_debited?).to eq true
      end

      it "credits the mentor" do
        expect(completed_call_request.mentor_credited?).to eq true
      end

      it "sets the status to processed" do
        expect(completed_call_request.status).to eq :processed
      end
    end

    context "#debit_amount" do
      before(:each) do
        call_request.stub(:billable_duration).and_return(900)
        call_request.mentor.stub(:rate_per_minute).and_return(3)
      end

      it "returns the correct amount to be debited from the member" do
        expect(call_request.debit_amount).to eq 4500
      end
    end

    context "#credit_amount" do
      before(:each) do
        call_request.stub(:debit_amount).and_return(100)
      end

      it "returns the correct amount to be credited to the mentor" do
        expect(call_request.credit_amount).to eq 70
      end
    end

    context "#description" do
      it "returns the correct description with member and mentor names" do
        expect(call_request.description).to eq "Shyne call with #{call_request.member.full_name} & #{call_request.mentor.full_name}"
      end
    end
  end
end
