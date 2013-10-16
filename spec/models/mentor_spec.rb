require 'spec_helper'

describe Mentor do
  it "has a valid factory" do
    expect(build(:mentor)).to be_valid
  end

  let(:mentor_instance) { create(:mentor) }
end