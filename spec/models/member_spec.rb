require 'spec_helper'

describe Member do
  it "has a valid factory" do
    expect(build(:member)).to be_valid
  end

  let(:member) { create(:member) }

  describe "ActiveModel validations" do
    context "Basic validations" do
      it { should validate_presence_of :user }
      it { should validate_presence_of :phone_number }
    end
  end

  describe "ActiveRecord validations" do
    context "Associations" do
      it { expect(member).to have_many(:call_request) }
    end
  end

  describe "Public class methods" do
    context "#full_name" do
      it "returns a member's full name as a string" do
        expect(member.full_name).to eq "#{member.user.first_name} #{member.user.last_name}"
      end
    end

    context "#email" do
      it "returns a member's email as a string" do
        expect(member.email).to eq "#{member.user.email}"
      end
    end
  end
end