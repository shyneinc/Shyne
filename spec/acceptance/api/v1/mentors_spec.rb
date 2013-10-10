require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Mentor' do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  get "/api/mentors" do
    parameter :featured, "Featured mentors or not"

    before do
      2.times do |i|
        mentor = FactoryGirl.attributes_for(:mentor)
        Mentor.create(mentor)
      end
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
  end

  delete "/api/mentors/:id" do
  end

  patch "/api/mentors/:id" do
  end
end