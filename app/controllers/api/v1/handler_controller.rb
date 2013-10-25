class Api::V1::HandlerController < ApplicationController
	#this will be a twilio call handler
	def index
		response = Twilio::TwiML::Response.new do |r|
			r.Say 'hello there'
		end

		render xml: response
	end
end
