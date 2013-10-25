require 'spec_helper'

describe Call do
  it "has a valid factory" do
    expect(build(:call)).to be_valid
  end

  let(:call) { create(:call) }
end
