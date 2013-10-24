require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Search' do
  header "Accept", "application/vnd.shyne.v1"

  get "/api/search" do
    parameter :q, "Search query"

    let(:q) { 'test' }

    example_request "Getting all matching search results" do
      expect(response_body).to eq PgSearch.multisearch(q).to_json
      expect(status).to eq 200
    end
  end
end