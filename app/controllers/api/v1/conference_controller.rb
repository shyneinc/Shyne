#twilio call handler

class Api::V1::ConferenceController < ApplicationController
	require 'nokogiri'
	respond_to :xml
	protect_from_forgery :except => ["finish"]

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
		@caller_number = params[:From]
		@sid = params[:CallSid]

		if @call
			@response = Twilio::TwiML::Response.new do |r|
				r.Say "Entering the Dojo!", voice: 'alice'
				r.Dial action: "#{root_url}api/conference/finish", method: :post do |d|
					d.Conference @call.passcode.to_s
				end
			end

			@call.call_histories.create(phone_number: @caller_number, sid: @sid, status: :inprogress)
		else
			@response = Twilio::TwiML::Response.new do |r|
				r.Say "I'm sorry you passcode in invalid", voice: 'alice'
			end
		end

		render :xml => Nokogiri::XML(@response.text)
	end

	def finish
		@clog = CallHistory.find_by sid: params[:CallSid]

		if @clog && params[:CallStatus] == "completed"

			@clog.conferencesid = params[:ConferenceSid]
			@clog.status = :completed
			@clog.save
			@clog.send_billing

			render :xml => { status: @clog.status.to_s }, status: 200
		else
			render :xml => { status: "Call ID not found"}, status: 401
		end
	end
end
