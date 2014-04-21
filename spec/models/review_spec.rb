require 'spec_helper'

describe Review do
  it "has a valid factory" do
    expect(build(:review)).to be_valid
  end

  let(:review) { create(:review) }

  describe "ActiveModel validations" do
    context "Basic validations" do
      it { should validate_presence_of :review }
      it { should validate_presence_of :rating }
      it { should validate_presence_of :mentor }
      it { should validate_presence_of :member }
      it { should ensure_inclusion_of(:rating).in_range(0..5) }
    end
  end

  describe "ActiveRecord validations" do
    context "Associations" do
      it { expect(review).to belong_to(:mentor) }
      it { expect(review).to belong_to(:member) }
      it { expect(review).to belong_to(:call) }
    end
  end
end
