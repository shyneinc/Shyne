class Api::V1::HandlerController < ApplicationController
	#this will be a twilio call handler
	respond_to :xml

	def index
		@response = Twilio::TwiML::Response.new do |r|
			r.Say 'hello there'
		end

		respond_with :api, @response.text
	end
end
