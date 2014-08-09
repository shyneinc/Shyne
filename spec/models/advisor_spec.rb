require 'spec_helper'

describe Advisor do
  it "has a valid factory" do
    expect(build(:advisor)).to be_valid
  end

  let(:advisor) { create(:advisor) }

  describe "ActiveModel validations" do
    context "Basic validations" do
      it { should validate_presence_of :user }
      it { should validate_presence_of :headline }
      it { should ensure_length_of(:headline).is_at_most(280) }
      it { should validate_presence_of :city }
      it { should validate_presence_of :state }
      it { should validate_presence_of :years_of_experience }
      it { should validate_numericality_of(:years_of_experience) }
      it { should validate_presence_of :availability }
      it { should validate_presence_of :phone_number }
      #it { should ensure_length_of(:phone_number).is_equal_to(11) }
      it { should_not allow_value('some random string').for(:linkedin) }
      it { should allow_value('http://www.linkedin.com/in/williamhgates').for(:linkedin) }
    end
  end

  describe "ActiveRecord validations" do
    context "Associations" do
      it { expect(advisor).to have_many(:call_requests) }
      it { expect(advisor).to have_many(:work_histories) }
    end

    context "Callbacks" do
      it { expect(advisor).to callback(:send_status_email).after(:update) }
      #TODO: Test additional callbacks
    end
  end

  describe "Public class methods" do
    context "#full_name" do
      it "returns a advisor's full name as a string" do
        expect(advisor.full_name).to eq "#{advisor.user.first_name} #{advisor.user.last_name}"
      end
    end

    context "#email" do
      it "returns a advisor's email as a string" do
        expect(advisor.email).to eq "#{advisor.user.email}"
      end
    end

    context "#years_of_experience" do
      it "returns a rate per minute according to advisor's experience" do
        if advisor.years_of_experience < 2
          expect(advisor.rate_per_minute).to eq 1
        elsif advisor.years_of_experience >= 2 && advisor.years_of_experience <= 7
          expect(advisor.rate_per_minute).to eq 2
        elsif advisor.years_of_experience > 7
          expect(advisor.rate_per_minute).to eq 3
        end
      end
    end

    context "#approved" do
      let!(:advisor1) { create(:advisor, advisor_status: AdvisorStatus::Approved.new) }
      let!(:advisor2) { create(:advisor) }
      let!(:advisor3) { create(:advisor, advisor_status: AdvisorStatus::Approved.new) }

      it "returns approved advisors" do
        expect(Advisor.approved).to include advisor1, advisor3
      end

      it "does not return unapproved advisors" do
        expect(Advisor.approved).to_not include advisor2
      end
    end

    context "#featured" do
      let!(:advisor1) { create(:advisor, featured: true) }
      let!(:advisor2) { create(:advisor, featured: false) }
      let!(:advisor3) { create(:advisor, featured: true) }

      it "returns featured advisors" do
        expect(Advisor.featured).to include advisor1, advisor3
      end

      it "does not return regular advisors" do
        expect(Advisor.featured).to_not include advisor2
      end
    end

    context "#fullname" do
      it "return fullname of the advisor same as it's user fullname" do
        expect(advisor.full_name).to eq advisor.user.full_name
      end
    end

    context "#avg_rating" do
      let(:advisor_with_reviews) { create(:advisor_with_reviews) }

      before(:all) do
        advisor_with_reviews.calc_avg_rating_without_delay
      end

      it "returns an average of all the ratings" do
        expect(advisor_with_reviews.avg_rating).to eq advisor_with_reviews.reviews.average('rating').to_f
      end
    end

    context "#avg_call_duration" do
      let(:advisor_with_calls) { create(:advisor_with_calls) }

      before(:all) do
        advisor_with_calls.calc_avg_duration_without_delay
      end

      it "returns an average call duration" do
        expect(advisor_with_calls.avg_call_duration).to eq advisor_with_calls.call_requests.average('billable_duration').to_f
      end
    end
  end
end