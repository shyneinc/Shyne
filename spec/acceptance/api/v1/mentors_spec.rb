require 'spec_helper'
require 'rspec_api_documentation/dsl'
require 'pg_array_parser'
include PgArrayParser

resource 'Mentor' do
  header "Accept", "application/vnd.shyne.v1"

  before(:each) do
    load "#{Rails.root}/db/seeds.rb"
  end

  let(:mentor) { FactoryGirl.create(:mentor) }

  get "/api/mentors" do
    parameter :featured, "Only list featured mentors"
    parameter :experties, "Only list mentors with specified experties"

    before do
      FactoryGirl.create_list(:mentor, 10)
    end

    example "Getting all mentors" do
      do_request
      response_body.should == Mentor.all.to_json
      status.should == 200
    end

    example "Getting featured mentors" do
      do_request(:featured => true)
      response_body.should == Mentor.featured.to_json
      status.should == 200
    end

    example "Getting mentors with specific experties" do
      do_request(:experties => 'Accounting')
      response_body.should == Mentor.experties('Accounting').to_json
      status.should == 200
    end
  end

  post "/api/mentors" do
    include Warden::Test::Helpers

    before do
      @user = FactoryGirl.create(:user)
      login_as @user, scope: :user
    end

    parameter :first_name, "First name", :required => true, :scope => :mentor
    parameter :last_name, "Last name", :required => true, :scope => :mentor
    parameter :headline, "Headline", :required => true, :scope => :mentor
    parameter :experties, "Experties (eg. '{Accounting, Finance}')", :required => true, :scope => :mentor
    parameter :years_of_experience, "Years of Experience", :required => true, :scope => :mentor
    parameter :phone_number, "Phone Number", :required => true, :scope => :mentor
    parameter :availability, "Availability", :required => true, :scope => :mentor

    example "Creating a mentor" do
      explanation "Once the user is registered and logged in, create a mentor profile"
      mentor = FactoryGirl.attributes_for(:mentor, :featured => nil).except(:id)
      do_request(mentor: mentor)

      hash = JSON.parse(response_body)
      hash.delete('mentor_status_id')
      hash.delete('status_changed_at')
      mentor[:user_id] = @user.id
      mentor[:experties] = parse_pg_array mentor[:experties]

      hash.to_json.should be_json_eql(mentor.to_json)
      status.should == 201
    end
  end

  get "/api/mentors/:id" do
    let(:id) { mentor.id }

    example_request "Getting a specific mentor" do
      response_body.should == mentor.to_json
      status.should == 200
    end
  end

  put "/api/mentors" do
    include Warden::Test::Helpers

    before do
      user = FactoryGirl.create(:mentor_user)
      login_as user, scope: :user
    end

    parameter :first_name, "First name", :required => true, :scope => :mentor
    parameter :last_name, "Last name", :required => true, :scope => :mentor
    parameter :headline, "Headline", :required => true, :scope => :mentor
    parameter :experties, "Experties (eg. '{Accounting, Finance}')", :required => true, :scope => :mentor
    parameter :years_of_experience, "Years of Experience", :required => true, :scope => :mentor
    parameter :phone_number, "Phone Number", :required => true, :scope => :mentor
    parameter :availability, "Availability", :required => true, :scope => :mentor

    example "Updating a mentor" do
      explanation "Update current user's mentor profile"
      mentor = FactoryGirl.attributes_for(:mentor, :featured => nil).except(:id)

      do_request(mentor: mentor)

      status.should == 204
    end
  end

  delete "/api/mentors" do
    include Warden::Test::Helpers

    before do
      user = FactoryGirl.create(:mentor_user)
      login_as user, scope: :user
    end

    example_request "Deleting a mentor" do
      explanation "Delete current user's mentor profile"
      status.should == 204
    end
  end
end