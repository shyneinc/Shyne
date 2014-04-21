require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Mentor' do
  header "Accept", "application/vnd.shyne.v1"

  let(:mentor) { create(:mentor) }

  get "/api/mentors" do
    parameter :featured, "Only list featured mentors"
    parameter :skills, "Only list mentors with specified skill"

    before :all do
      create_list(:mentor, 10)
    end

    example "Getting all approved mentors" do
      do_request

      expect(response_body).to eq Mentor.approved.to_json
      expect(status).to eq 200
    end

    example "Getting approved & featured mentors" do
      do_request(:featured => true)

      expect(response_body).to eq Mentor.approved.featured.to_json
      expect(status).to eq 200
    end

    example "Getting approved mentors with specific skill" do
      do_request(:skills => 'Word')

      expect(response_body).to eq Mentor.approved.skills('Rails').to_json
      expect(status).to eq 200
    end

    example "Getting approved mentors with specific industry expertise" do
      do_request(:industries => 'Finance')

      expect(response_body).to eq Mentor.approved.industries('Finance').to_json
      expect(status).to eq 200
    end

    after :all do
      Mentor.delete_all
    end
  end

  post "/api/mentors" do
    include Warden::Test::Helpers

    before do
      @user = create(:user)
      login_as @user, scope: :user
    end

    parameter :headline, "Headline", :required => true, :scope => :mentor
    parameter :location, "Location", :required => true, :scope => :mentor
    parameter :skills, "Skills (eg. '{Word, Programming}')", :required => true, :scope => :mentor
    parameter :industries, "Industries (eg. '{Accounting, Finance}')", :required => true, :scope => :mentor
    parameter :years_of_experience, "Years of Experience", :required => true, :scope => :mentor
    parameter :phone_number, "Phone Number", :required => true, :scope => :mentor
    parameter :availability, "Availability", :required => true, :scope => :mentor
    parameter :linkedin, "LinkedIn url", :required => false, :scope => :mentor

    example "Creating a mentor" do
      explanation "Once the user is registered and logged in, create a mentor profile"
      mentor = attributes_for(:mentor, :featured => nil).except(:id)
      do_request(mentor: mentor)

      hash = JSON.parse(response_body)
      mentor[:user_id] = @user.id
      mentor[:phone_number] = PhonyRails.normalize_number(mentor[:phone_number], :country_code => 'US')

      expect(hash.to_json).to be_json_eql mentor.to_json
      expect(status).to eq 201
    end
  end

  get "/api/mentors/:id" do
    let(:id) { mentor.id }

    example_request "Getting a specific mentor" do
      expect(response_body).to eq mentor.to_json({:include => [:user],
                                                  :methods => [:full_name, :avatar, :rate_per_minute, :get_avg_rating, :current_position, :current_company, :currently_working_at, :previously_worked_at, :avg_call_duration, :total_calls]})
      expect(status).to eq 200
    end
  end

  put "/api/mentors" do
    include Warden::Test::Helpers

    before do
      user = create(:mentor_user)
      login_as user, scope: :user
    end

    parameter :headline, "Headline", :required => true, :scope => :mentor
    parameter :location, "Location", :required => true, :scope => :mentor
    parameter :skills, "Skills (eg. '{Accounting, Finance}')", :required => true, :scope => :mentor
    parameter :industries, "Industries (eg. '{Accounting, Finance}')", :required => true, :scope => :mentor
    parameter :years_of_experience, "Years of Experience", :required => true, :scope => :mentor
    parameter :phone_number, "Phone Number", :required => true, :scope => :mentor
    parameter :availability, "Availability", :required => true, :scope => :mentor
    parameter :linkedin, "LinkedIn url", :required => false, :scope => :mentor

    example "Updating a mentor" do
      explanation "Update current user's mentor profile"
      mentor = attributes_for(:mentor, :featured => nil).except(:id)

      do_request(mentor: mentor)

      expect(status).to eq 204
    end
  end

  delete "/api/mentors" do
    include Warden::Test::Helpers

    before do
      user = create(:mentor_user)
      login_as user, scope: :user
    end

    example_request "Deleting a mentor" do
      explanation "Delete current user's mentor profile"

      expect(status).to eq 204
    end
  end
end