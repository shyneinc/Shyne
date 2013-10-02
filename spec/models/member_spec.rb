require 'spec_helper'

describe Member do
  it "has a valid factory" do
    expect(build(:member)).to be_valid
  end

  let(:member_instance) { create(:member) }
end