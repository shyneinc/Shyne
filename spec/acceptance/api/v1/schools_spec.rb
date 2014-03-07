require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'School' do
  header "Accept", "application/vnd.shyne.v1"

  get "/api/schools" do
    example_request "Show available schools" do
      expect(response_body).to eq School.select(:id, :name).to_json
      expect(status).to eq 200
    end
  end
end