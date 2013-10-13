require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Mentor' do
  header "Accept", "application/vnd.shyne.v1"

  before(:each) do
    load "#{Rails.root}/db/seeds.rb"
  end

  let(:mentor) { FactoryGirl.create(:mentor) }

  get "/api/mentors" do
    parameter :featured, "Only list featured mentors"

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
  end

  post "/api/mentors" do
    parameter :first_name, "First name", :required => true, :scope => :mentor
    parameter :last_name, "Last name", :required => true, :scope => :mentor
    parameter :headline, "Headline", :required => true, :scope => :mentor
    parameter :years_of_experience, "Headline", :required => true, :scope => :mentor
    parameter :phone_number, "Phone Number", :required => true, :scope => :mentor
    parameter :availability, "Availability", :required => true, :scope => :mentor
    parameter :email, "Email", :scope => :user_attributes
    parameter :password, "Password", :scope => :user_attributes
    parameter :password_confirmation, "Password Confirmation", :scope => :user_attributes

    example "Registering a mentor" do
      mentor = FactoryGirl.attributes_for(:mentor, :featured => nil).except(:id)
      mentor[:user_attributes] = FactoryGirl.attributes_for(:user).except(:id)
      do_request(mentor: mentor)

      hash = JSON.parse(response_body)
      hash.delete('user_id')
      hash.delete('mentor_status_id')
      hash.delete('status_changed_at')

      hash.to_json.should be_json_eql(mentor.except(:user_attributes).to_json)

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

  put "/api/mentors/:id" do
    parameter :first_name, "First name", :required => true, :scope => :mentor
    parameter :last_name, "Last name", :required => true, :scope => :mentor
    parameter :headline, "Headline", :required => true, :scope => :mentor
    parameter :years_of_experience, "Headline", :required => true, :scope => :mentor
    parameter :phone_number, "Phone Number", :required => true, :scope => :mentor
    parameter :availability, "Availability", :required => true, :scope => :mentor

    let(:id) { mentor.id }

    example "Updating a mentor" do
      mentor = FactoryGirl.attributes_for(:mentor, :featured => nil).except(:id)
      do_request(mentor: mentor)

      status.should == 204
    end
  end

  delete "/api/mentors/:id" do
    let(:id) { mentor.id }

    example_request "Deleting a mentor" do
      status.should == 204
    end
  end
end