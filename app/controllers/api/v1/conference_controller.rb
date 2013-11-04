#twilio call handler

class Api::V1::ConferenceController < ApplicationController
	require 'nokogiri'
	respond_to :xml

	def initiate
		@response = Twilio::TwiML::Response.new do |r|
			r.Gather action: "#{root_url}api/conference/start", method: 'GET', numDigits: 5, timeout: 10 do |f|
				f.Say "Greetings! Welcome to Shyne!" , voice: 'alice'
				f.Say "Enter Passcode:", voice: 'alice'
			end
		end

		render :xml => Nokogiri::XML(@response.text)
	end

	def start
		@call = Call.find_by passcode: params[:Digits]

		if @call
			@call.sid = params[:CallSid]
			@call.state = params[:CallStatus]

			@response = Twilio::TwiML::Response.new do |r|
				r.Say "Entering the Dojo!", voice: 'alice'
				r.Dial action: "#{root_url}api/conference/finish", method: :post do |d|
					d.Conference @call.passcode.to_s
				end
			end
		else
			@response = Twilio::TwiML::Response.new do |r|
				r.Say "I'm sorry you passcode in invalid", voice: 'alice'
			end
		end


		render :xml => Nokogiri::XML(@response.text)
	end

	def finish
		@call = Call.find_by sid: params[:CallSid]

		if @call
			#look-up account log for duration and save it to model
		end
	end
end
