require 'spec_helper'

describe Mentor do
  it "has a valid factory" do
    expect(build(:mentor)).to be_valid
  end

  let(:mentor) { create(:mentor) }

  describe "ActiveModel validations" do
    context "Basic validations" do
      it { should validate_presence_of :user }
      it { should validate_presence_of :headline }
      it { should validate_presence_of :location }
      it { should validate_presence_of :experties }
      it { should validate_presence_of :years_of_experience }
      it { should validate_numericality_of(:years_of_experience) }
      it { should validate_presence_of :availability }
      it { should validate_presence_of :phone_number }
    end
  end

  describe "ActiveRecord validations" do
    context "Associations" do
      it { expect(mentor).to have_many(:call_requests) }
      it { expect(mentor).to have_many(:work_histories) }
    end

    context "Callbacks" do
      it { expect(mentor).to callback(:send_status_email).after(:update) }
      #TODO: Test additional callbacks
    end
  end

  describe "Public class methods" do
    context "#full_name" do
      it "returns a mentor's full name as a string" do
        expect(mentor.full_name).to eq "#{mentor.user.first_name} #{mentor.user.last_name}"
      end
    end

    context "#email" do
      it "returns a mentor's email as a string" do
        expect(mentor.email).to eq "#{mentor.user.email}"
      end
    end

    context "#years_of_experience" do
      it "returns a rate per minute according to mentor's experience" do
        if mentor.years_of_experience < 2
          expect(mentor.rate_per_minute).to eq 1
        elsif mentor.years_of_experience >= 2 && mentor.years_of_experience <= 7
          expect(mentor.rate_per_minute).to eq 2
        elsif mentor.years_of_experience > 7
          expect(mentor.rate_per_minute).to eq 3
        end
      end
    end

    context "#approved" do
      let!(:mentor1) { create(:mentor, mentor_status: MentorStatus::Approved.new) }
      let!(:mentor2) { create(:mentor) }
      let!(:mentor3) { create(:mentor, mentor_status: MentorStatus::Approved.new) }

      it "returns approved mentors" do
        expect(Mentor.approved).to include mentor1, mentor3
      end

      it "does not return unapproved mentors" do
        expect(Mentor.approved).to_not include mentor2
      end
    end

    context "#featured" do
      let!(:mentor1) { create(:mentor, featured: true) }
      let!(:mentor2) { create(:mentor, featured: false) }
      let!(:mentor3) { create(:mentor, featured: true) }

      it "returns featured mentors" do
        expect(Mentor.featured).to include mentor1, mentor3
      end

      it "does not return regular mentors" do
        expect(Mentor.featured).to_not include mentor2
      end
    end

    context "#experties" do
      let!(:mentor1) { create(:mentor, experties: '{Accounting,Banking}') }
      let!(:mentor2) { create(:mentor, experties: '{Banking}') }
      let!(:mentor3) { create(:mentor, experties: '{Programming}') }

      it "returns mentors with the specified experties" do
        expect(Mentor.experties('Banking')).to include mentor1, mentor2
      end

      it "does not return mentors with an unspecific experties" do
        expect(Mentor.experties('Banking')).to_not include mentor3
      end
    end

    context "#fullname" do
      it "return fullname of the mentor same as it's user fullname" do
        expect(mentor.full_name).to eq mentor.user.full_name
      end
    end
  
    context "#avg_rating" do
      let(:mentor_with_reviews){ create(:mentor_with_reviews) }

      before(:all) do
        mentor_with_reviews.calc_avg_rating_without_delay
      end

      it "returns an average of all the ratings" do
        expect(mentor_with_reviews.avg_rating).to eq mentor_with_reviews.reviews.average('rating').to_f
      end
    end

    context "#avg_call_duration" do
      let(:mentor_with_calls){ create(:mentor_with_calls) }

      before(:all) do
        mentor_with_calls.calc_avg_duration_without_delay
      end

      it "returns an average call duration" do
        expect(mentor_with_calls.avg_call_duration).to eq mentor_with_calls.call_requests.average('billable_duration').to_f
      end
    end
  end
end