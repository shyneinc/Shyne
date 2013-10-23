require 'spec_helper'
require 'rspec_api_documentation/dsl'
require 'pg_array_parser'
include PgArrayParser

resource 'WorkHistory' do
	header "Accept", "application/vnd.shyne.v1"

	before(:all) do
		load "#{Rails.root}/db/seeds.rb"
	end

	let(:mentor) { create(:mentor) }

	get "/api/mentors/:mentor_id/work_histories" do
		example "Get all work historoy" do

		end
	end

	post "/api/mentors/:mentor_id/work_histories" do
		example "Creating a work history" do
			
		end
	end
end