class Api::V1::HandlerController < ApplicationController
	#this will be a twilio call handler
	respond_to :xml

	def index
		@response = Twilio::TwiML::Response.new do |r|
			r.Say "Greetings! Welcome to Shyne Conference"
			r.Dial do |f|
				f.Conference "Room 808"
			end
		end

		respond_with xml: @response.text
	end
end
