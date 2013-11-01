require 'spec_helper'
require 'rspec_api_documentation/dsl'
include Warden::Test::Helpers

resource 'Review' do
  header "Accept", "application/vnd.shyne.v1"

  let(:mentor) { create(:mentor) }
  let(:mentor_id) { mentor.id }

  let(:user) { create(:member_user) }
  let(:review) { create(:review, mentor: mentor, member: user.role) }

  get "/api/mentors/:mentor_id/reviews" do

    parameter :mentor_id, "Mentor ID", required: true

    example "Getting all mentor reviews" do
      do_request

      expect(response_body).to eq mentor.reviews.to_json
      expect(status).to eq 200
    end
  end

  post "/api/mentors/:mentor_id/reviews" do

    before (:each) do
      login_as user, scope: :user
    end

    parameter :mentor_id, "Mentor ID", required: true
    parameter :review, "Review", required: true, scope: :review
    parameter :call_id, "Call ID", required: false, scope: :review

    example "Create a review" do
      explanation "Once the call is completed, a member can write a review"
      review = FactoryGirl.attributes_for(:review, member: user.role)
      do_request(review: review)

      hash = JSON.parse(response_body)
      review[:mentor_id] = mentor_id
      review[:member_id] = user.role.id
      review[:call_id] = nil

      expect(hash.to_json).to be_json_eql review.to_json
      expect(status).to eq 201
    end
  end

  put "/api/mentors/:mentor_id/reviews/:id" do

    before do
      login_as user, scope: :user
    end

    parameter :id, "Review ID", required: true
    parameter :mentor_id, "Mentor ID", required: true
    parameter :review, "Review", required: true, scope: :review
    parameter :call_id, "Call ID", required: false, scope: :review

    example "Update a review" do
      updated_review = attributes_for(:review, member: user.role).except(:id)

      do_request(review: updated_review, id: review.id, mentor_id: review.mentor_id)

      expect(status).to eq 204
    end
  end

  delete "/api/mentors/:mentor_id/reviews/:id" do

    before do
      login_as user, scope: :user
    end

    parameter :id, "Review ID", required: true
    parameter :mentor_id, "Mentor ID", required: true

    example "Deleting a review" do

      do_request(id: review.id)

      expect(status).to eq 204
    end
  end
end