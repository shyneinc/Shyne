require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Search' do
  header "Accept", "application/vnd.shyne.v1"

  get "/api/search" do
    parameter :q, "Search query", :required => true
    parameter :pg, "Page number", :required => false

    let(:q) { 'banking' }
    let(:pg) { 1 }

    example_request "Getting all matching search results" do
      explanation "This endpoint will search for Mentor's full name, headline, location, experties and work history to find a match"
      #TODO: Test results
      expect(status).to eq 200
    end
  end
end