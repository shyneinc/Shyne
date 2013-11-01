require 'spec_helper'

describe Review do
  it "has a valid factory" do
    expect(build(:review)).to be_valid
  end

  let(:review) { create(:review) }
end
