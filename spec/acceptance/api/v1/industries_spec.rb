require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Industry' do
  header "Accept", "application/vnd.shyne.v1"

  get "/api/industries" do
    example_request "Show available industries" do
      expect(response_body).to eq Industry.select(:id, :title).to_json
      expect(status).to eq 200
    end
  end
end