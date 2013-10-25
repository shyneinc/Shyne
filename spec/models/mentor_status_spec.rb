require 'spec_helper'

describe MentorStatus do
  it "has a valid factory" do
    expect(build(:mentor_status)).to be_valid
  end
end
