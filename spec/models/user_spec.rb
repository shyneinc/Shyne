require 'spec_helper'

describe User do
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  let(:user) { create(:user) }

  describe "ActiveModel validations" do
    context "Basic validations" do
      it { should validate_presence_of :first_name }
      it { should validate_presence_of :last_name }
      it { should validate_presence_of :email }
      it { should validate_presence_of :password }
    end
  end

  describe "ActiveRecord validations" do
    context "Callbacks" do
      it { expect(user).to callback(:generate_username).after(:validation).on(:create) }
    end
  end

end