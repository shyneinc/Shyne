require 'spec_helper'

describe Mentor do
  it "has a valid factory" do
    expect(build(:mentor)).to be_valid
  end

  let(:mentor) { create(:mentor) }

  describe "ActiveModel validations" do
    context "Basic validations" do
      it { should validate_presence_of :headline }
      it { should validate_presence_of :experties }
      it { should validate_presence_of :years_of_experience }
      it { should validate_numericality_of(:years_of_experience) }
      it { should validate_presence_of :availability }
      it { should validate_presence_of :phone_number }
    end
  end

  describe "ActiveRecord validations" do
    context "Associations" do
      it { expect(mentor).to belong_to(:mentor_status) }
      it { expect(mentor).to have_many(:calls) }
      it { expect(mentor).to have_many(:work_histories) }
    end

    context "Callbacks" do
      it { expect(mentor).to callback(:send_status_email).after(:update) }
    end
  end

  describe "Public class methods" do
    context "#full_name" do
      it "returns a mentor's full name as a string" do
        expect(mentor.full_name).to eq "#{mentor.user.first_name} #{mentor.user.last_name}"
      end
    end

    context "#years_of_experience" do
      it "returns a rate per minute according to mentor's experience" do
        if mentor.years_of_experience < 2
          expect(mentor.rate_per_minute).to eq 1.0
        elsif mentor.years_of_experience >= 2 && mentor.years_of_experience <= 7
          expect(mentor.rate_per_minute).to eq 2.0
        elsif mentor.years_of_experience > 7
          expect(mentor.rate_per_minute).to eq 3.0
        end
      end
    end

    context "#approved" do
      let!(:mentor1) { create(:mentor, mentor_status_id: MentorStatus.by_status('Approved').id) }
      let!(:mentor2) { create(:mentor) }
      let!(:mentor3) { create(:mentor, mentor_status_id: MentorStatus.by_status('Approved').id) }

      it "returns an array of approved mentors" do
        expect(Mentor.approved).to include mentor1, mentor3
        expect(Mentor.approved).to_not include mentor2
      end
    end

    context "#featured" do
      let!(:mentor1) { create(:mentor, featured: true) }
      let!(:mentor2) { create(:mentor, featured: false) }
      let!(:mentor3) { create(:mentor, featured: true) }

      it "returns an array of featured mentors" do
        expect(Mentor.featured).to include mentor1, mentor3
        expect(Mentor.featured).to_not include mentor2
      end
    end

    context "#experties" do
      let!(:mentor1) { create(:mentor, experties: '{Accounting,Banking}') }
      let!(:mentor2) { create(:mentor, experties: '{Banking}') }
      let!(:mentor3) { create(:mentor, experties: '{Programming}') }

      it "returns an array of mentors with specific experties" do
        expect(Mentor.experties('Banking')).to include mentor1, mentor2
        expect(Mentor.experties('Banking')).to_not include mentor3
      end
    end
  end
end