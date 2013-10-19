require 'spec_helper'

describe Mentor do
  it "has a valid factory" do
    expect(build(:mentor)).to be_valid
  end

  describe "ActiveModel validations" do
    context "Basic validations" do
      it { should validate_presence_of :headline }
      it { should validate_presence_of :experties }
      it { should validate_presence_of :years_of_experience }
      it { should validate_presence_of :availability }
      it { should validate_presence_of :phone_number }
    end
  end

  it "returns a mentor's full name as a string" do
    mentor = build_stubbed(:mentor)
    expect(mentor.full_name).to eq "#{mentor.user.first_name} #{mentor.user.last_name}"
  end

  describe "filter by featured mentors" do
    let!(:mentor1) { create(:mentor, featured: true) }
    let!(:mentor2) { create(:mentor, featured: false) }
    let!(:mentor3) { create(:mentor, featured: true) }

    context "matching mentors" do
      it "returns an array of results that match" do
        expect(Mentor.featured).to eq [mentor1, mentor3]
      end
    end

    context "non-matching mentors" do
      it "returns an array of results that match" do
        expect(Mentor.featured).to_not include mentor2
      end
    end
  end
end