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

		render :xml => Nokogiri::XML(@response.text)
	end
end
