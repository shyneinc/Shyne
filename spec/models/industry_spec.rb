require 'spec_helper'

describe Industry do
  it "has a valid factory" do
    expect(build(:industry)).to be_valid
  end

  let(:industry) { create(:industry) }
end
