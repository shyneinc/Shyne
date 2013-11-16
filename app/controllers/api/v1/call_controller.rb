#twilio call handler
class Api::V1::CallController < ActionController::Base
  require 'nokogiri'
  respond_to :xml
  protect_from_forgery :except => ["finish"]

  def initiate
    @response = Twilio::TwiML::Response.new do |r|
      r.Gather action: api_call_start_url, method: :post, numDigits: 5, timeout: 10 do |f|
        f.Say "Greetings! Welcome to Shyne!", voice: 'alice'
        f.Say "Enter Passcode:", voice: 'alice'
      end
    end

    render :xml => Nokogiri::XML(@response.text), status: 200
  end

  def start
    @call_request = CallRequest.find_by passcode: params[:Digits]
    @caller_number = params[:From]
    @sid = params[:CallSid]

    #TODO: restrict passcode by time - can't use passcode 30minutes before or after scheduled call_request
    if @call_request
      @response = Twilio::TwiML::Response.new do |r|
        r.Say "Entering the Dojo!", voice: 'alice'
        r.Dial action: api_call_finish_url, method: :post do |d|
          d.Conference @call_request.passcode.to_s, maxParticipants: 3, endConferenceOnExit: true
        end
      end

      @call_request.calls.create(from_number: @caller_number, sid: @sid, status: :inprogress)
    else
      @response = Twilio::TwiML::Response.new do |r|
        r.Say "I'm sorry your passcode in invalid", voice: 'alice'
      end
    end

    render :xml => Nokogiri::XML(@response.text), status: 200
  end

  def finish
    @call = Call.find_by sid: params[:CallSid]

    if @call
      if params[:CallStatus] == "completed"
        @call.conferencesid = params[:ConferenceSid]
        @call.status = params[:CallStatus]
        @call.save

        render :xml => {status: @call.status.to_s}, status: 200
      elsif params[:CallStatus] == "in-progress"
        @response = Twilio::TwiML::Response.new do |r|
          r.Say "Thank you for using Shyne"
          r.Hangup
        end
        
        @call.conferencesid = params[:ConferenceSid]
        @call.save

        render :xml => Nokogiri::XML(@response.text), status: 200
      else
        @call.status = params[:CallStatus]
        @call.save

        render :xml => {status: @call.status.to_s}, status: 200
      end
    else
      render :xml => {status: "Call request ID not found"}, status: 401
    end
  end
end
