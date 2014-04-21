require 'spec_helper'

describe Call do
  it "has a valid factory" do
    expect(build(:call)).to be_valid
  end

  let(:call) { create(:call) }

  describe "ActiveModel validations" do
    context "Basic validations" do
      it { should validate_presence_of :sid }
      it { should validate_presence_of :from_number }
    end
  end

  describe "ActiveModel validations" do
    context "Associations" do
      it { expect(call).to have_many(:reviews) }
      it { expect(call).to belong_to(:call_request) }
    end
  end


end
