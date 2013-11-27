require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Member' do
  header "Accept", "application/vnd.shyne.v1"

  let(:member) { create(:member) }

  get "/api/members" do
    before do
      create_list(:member, 10)
    end

    example_request "Getting all members" do
      expect(response_body).to eq Member.all.to_json
      expect(status).to eq 200
    end
  end

  post "/api/members" do
    include Warden::Test::Helpers

    before do
      @user = create(:user)
      login_as @user, scope: :user
    end

    parameter :phone_number, "Phone number", :required => true, :scope => :member

    example "Creating a member" do
      explanation "Once the user is registered and logged in, create a member profile"
      member = attributes_for(:member).except(:id)
      do_request(member: member)

      hash = JSON.parse(response_body)
      member[:user_id] = @user.id
      member[:phone_number] = PhonyRails.normalize_number(member[:phone_number], :country_code => 'US')

      expect(hash.to_json).to be_json_eql(member.to_json)
      expect(status).to eq 201
    end
  end

  get "/api/members/:id" do
    let(:id) { member.id }

    example_request "Getting a specific member" do
      expect(response_body).to eq member.to_json
      expect(status).to eq 200
    end
  end

  put "/api/members" do
    include Warden::Test::Helpers

    before do
      user = create(:member_user)
      login_as user, scope: :user
    end

    parameter :phone_number, "Phone number", :required => true, :scope => :member

    let(:id) { member.id }

    example "Updating a member" do
      explanation "Update current user's member profile"
      member = attributes_for(:member).except(:id)
      do_request(member: member)

      expect(status).to eq 204
    end
  end

  delete "/api/members" do
    include Warden::Test::Helpers

    before do
      user = create(:member_user)
      login_as user, scope: :user
    end

    example_request "Deleting a member" do
      explanation "Delete current user's member profile"
      expect(status).to eq 204
    end
  end
end