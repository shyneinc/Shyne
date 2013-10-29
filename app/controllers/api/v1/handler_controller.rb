class Api::V1::HandlerController < ApplicationController
	#this will be a twilio call handler
	require 'nokogiri'
	respond_to :xml

	def index
		@response = Twilio::TwiML::Response.new do |r|
			r.Gather action: "#{root_url}handler/conference", method: 'GET', numDigits: 5, timeout: 10 do |f|
				f.Say "Greetings! Welcome to Shyne!" , voice: 'alice'
				f.Say "Enter Passcode:", voice: 'alice'
			end
		end

		render :xml => Nokogiri::XML(@response.text)
	end

	def conference
		@user_input = params[:Digits]

		@response = Twilio::TwiML::Response.new do |r|
			r.Say "Entering the Dojo!", voice: 'alice'
			r.Dial do |d|
				d.Conference @user_input
			end
		end

		render :xml => Nokogiri::XML(@response.text)
	end
end
