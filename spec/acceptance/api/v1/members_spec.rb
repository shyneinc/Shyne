require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Member' do
  header "Accept", "application/vnd.shyne.v1"

  let(:member) {
    FactoryGirl.create(:member)
  }

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
    parameter :first_name, "First name", :required => true, :scope => :member
    parameter :last_name, "Last name", :required => true, :scope => :member
    parameter :email, "Email", :scope => :user_attributes
    parameter :password, "Password", :scope => :user_attributes
    parameter :password_confirmation, "Password Confirmation", :scope => :user_attributes

    example "Registering a member" do
      member = FactoryGirl.attributes_for(:member).except(:id)
      member[:user_attributes] = FactoryGirl.attributes_for(:user).except(:id)
      do_request(member: member)

      hash = JSON.parse(response_body)
      hash.delete('user_id')

      hash.to_json.should be_json_eql(member.except(:user_attributes).to_json)

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

  put "/api/members/:id" do
    parameter :first_name, "First name", :required => true, :scope => :member
    parameter :last_name, "Last name", :required => true, :scope => :member

    let(:id) { member.id }

    example "Updating a member" do
      member = FactoryGirl.attributes_for(:member).except(:id)
      do_request(member: member)

      status.should == 204
    end
  end

  delete "/api/members/:id" do
    let(:id) { member.id }

    example_request "Deleting a member" do
      status.should == 204
    end
  end
end