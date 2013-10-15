require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Member' do
  header "Accept", "application/vnd.shyne.v1"

  let(:member) { FactoryGirl.create(:member) }

  get "/api/members" do
    before do
      FactoryGirl.create_list(:member, 10)
    end

    example_request "Getting all members" do
      response_body.should == Member.all.to_json
      status.should == 200
    end
  end

  post "/api/members" do
    include Warden::Test::Helpers

    before do
      user = FactoryGirl.create(:user)
      login_as user, scope: :user
    end

    parameter :first_name, "First name", :required => true, :scope => :member
    parameter :last_name, "Last name", :required => true, :scope => :member

    example "Creating a member" do
      explanation "Once the user is registered and logged in, create a member profile"
      member = FactoryGirl.attributes_for(:member).except(:id)
      do_request(member: member)

      hash = JSON.parse(response_body)
      hash.delete('user_id')

      hash.to_json.should be_json_eql(member.to_json)

      status.should == 201
    end
  end

  get "/api/members/:id" do
    let(:id) { member.id }

    example_request "Getting a specific member" do
      response_body.should == member.to_json
      status.should == 200
    end
  end

  put "/api/members" do
    include Warden::Test::Helpers

    before do
      user = FactoryGirl.create(:member_user)
      login_as user, scope: :user
    end

    parameter :first_name, "First name", :required => true, :scope => :member
    parameter :last_name, "Last name", :required => true, :scope => :member

    let(:id) { member.id }

    example "Updating a member" do
      explanation "Update current user's member profile"
      member = FactoryGirl.attributes_for(:member).except(:id)
      do_request(member: member)

      status.should == 204
    end
  end

  delete "/api/members" do
    include Warden::Test::Helpers

    before do
      user = FactoryGirl.create(:member_user)
      login_as user, scope: :user
    end

    example_request "Deleting a member" do
      explanation "Delete current user's member profile"
      status.should == 204
    end
  end
end