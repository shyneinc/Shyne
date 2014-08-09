require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Advisor' do
  header "Accept", "application/vnd.shyne.v1"

  let(:advisor) { create(:advisor) }

  get "/api/advisors" do
    parameter :featured, "Only list featured advisors"
    parameter :skills, "Only list advisors with specified skill"

    before :all do
      create_list(:advisor, 10)
    end

    example "Getting all approved advisors" do
      do_request

      expect(response_body).to eq Advisor.approved.to_json
      expect(status).to eq 200
    end

    example "Getting approved & featured advisors" do
      do_request(:featured => true)

      expect(response_body).to eq Advisor.approved.featured.to_json
      expect(status).to eq 200
    end

    example "Getting approved advisors with specific skill" do
      do_request(:skills => 'Word')

      expect(response_body).to eq Advisor.approved.skills('Rails').to_json
      expect(status).to eq 200
    end

    example "Getting approved advisors with specific industry expertise" do
      do_request(:industries => 'Finance')

      expect(response_body).to eq Advisor.approved.industries('Finance').to_json
      expect(status).to eq 200
    end

    after :all do
      Advisor.delete_all
    end
  end

  post "/api/advisors" do
    include Warden::Test::Helpers

    before do
      @user = create(:user)
      login_as @user, scope: :user
    end

    parameter :headline, "Headline", :required => true, :scope => :advisor
    parameter :location, "Location", :required => true, :scope => :advisor
    parameter :skills, "Skills (eg. '{Word, Programming}')", :required => true, :scope => :advisor
    parameter :industries, "Industries (eg. '{Accounting, Finance}')", :required => true, :scope => :advisor
    parameter :years_of_experience, "Years of Experience", :required => true, :scope => :advisor
    parameter :phone_number, "Phone Number", :required => true, :scope => :advisor
    parameter :availability, "Availability", :required => true, :scope => :advisor
    parameter :linkedin, "LinkedIn url", :required => false, :scope => :advisor

    example "Creating an advisor" do
      explanation "Once the user is registered and logged in, create an advisor profile"
      advisor = attributes_for(:advisor, :featured => nil).except(:id)
      do_request(advisor: advisor)

      hash = JSON.parse(response_body)
      advisor[:user_id] = @user.id
      advisor[:phone_number] = PhonyRails.normalize_number(advisor[:phone_number], :country_code => 'US')

      expect(hash.to_json).to be_json_eql advisor.to_json
      expect(status).to eq 201
    end
  end

  get "/api/advisors/:id" do
    let(:id) { advisor.id }

    example_request "Getting a specific advisor" do
      expect(response_body).to eq advisor.to_json({:include => [:user],
                                                  :methods => [:full_name, :avatar, :rate_per_minute, :get_avg_rating, :current_position, :current_company, :currently_working_at, :previously_worked_at, :avg_call_duration, :total_calls]})
      expect(status).to eq 200
    end
  end

  put "/api/advisors" do
    include Warden::Test::Helpers

    before do
      user = create(:advisor_user)
      login_as user, scope: :user
    end

    parameter :headline, "Headline", :required => true, :scope => :advisor
    parameter :location, "Location", :required => true, :scope => :advisor
    parameter :skills, "Skills (eg. '{Accounting, Finance}')", :required => true, :scope => :advisor
    parameter :industries, "Industries (eg. '{Accounting, Finance}')", :required => true, :scope => :advisor
    parameter :schools, "Schools (eg. '{Alabama A & M University, Amridge University}')", :required => true, :scope => :advisor
    parameter :years_of_experience, "Years of Experience", :required => true, :scope => :advisor
    parameter :phone_number, "Phone Number", :required => true, :scope => :advisor
    parameter :availability, "Availability", :required => true, :scope => :advisor
    parameter :linkedin, "LinkedIn url", :required => false, :scope => :advisor

    example "Updating an advisor" do
      explanation "Update current user's advisor profile"
      advisor = attributes_for(:advisor, :featured => nil).except(:id)

      do_request(advisor: advisor)

      expect(status).to eq 204
    end
  end

  delete "/api/advisors" do
    include Warden::Test::Helpers

    before do
      user = create(:advisor_user)
      login_as user, scope: :user
    end

    example_request "Deleting an advisor" do
      explanation "Delete current user's advisor profile"

      expect(status).to eq 204
    end
  end
end