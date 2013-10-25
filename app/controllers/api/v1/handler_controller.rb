class Api::V1::HandlerController < ApplicationController
	#this will be a twilio call handler
	require 'nokogiri'
	respond_to :xml

	def index
		@response = Twilio::TwiML::Response.new do |r|
			r.Say "Greetings! Welcome to Shyne Conference"
			r.Dial do |f|
				f.Conference "Room 808"
			end
		end

		hash = Hash.from_xml(@response.text)

		render :xml => hash.to_xml(:root => "Response", :skip_types => true)
	end
end
