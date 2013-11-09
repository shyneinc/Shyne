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
    end

    context "Callbacks" do
      it { expect(call_request).to callback(:generate_passcode).after(:validation).on(:create) }
      it { expect(call_request).to callback(:send_status_update).after(:update) }
    end
  end
end
