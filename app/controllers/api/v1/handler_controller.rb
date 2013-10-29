#twilio call handler

class Api::V1::HandlerController < ApplicationController
	require 'nokogiri'
	respond_to :xml

	def index
		@response = Twilio::TwiML::Response.new do |r|
			r.Gather action: "#{root_url}api/handler/conference", method: 'GET', numDigits: 5, timeout: 10 do |f|
				f.Say "Greetings! Welcome to Shyne!" , voice: 'alice'
				f.Say "Enter Passcode:", voice: 'alice'
			end
		end

		render :xml => Nokogiri::XML(@response.text)
	end

	def conference
		@user_input = params[:Digits]

		@response = Twilio::TwiML::Response.new do |r|
			if !@user_input.nil?
				r.Say "Entering the Dojo!", voice: 'alice'
				r.Dial do |d|
					d.Conference @user_input.to_s
				end
			else
				r.Say "I'm sorry you passcode in invalid", voice: 'alice'
			end
		end

		render :xml => Nokogiri::XML(@response.text)
	end
end
