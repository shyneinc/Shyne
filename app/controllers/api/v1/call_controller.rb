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

    if @call_request
      @response = Twilio::TwiML::Response.new do |r|
        r.Say "Entering the Dojo!", voice: 'alice'
        r.Dial action: api_call_finish_url, method: :post do |d|
          d.Conference @call_request.passcode.to_s
        end
      end

      # TODO:
      # 1) Check if the call recrod already exists - If it does, continue to #2 else go to #4
      # 2) Make sure that there are no calls with status "completed" with this passcode. If there are, don't do anything else continue to #3.
      # 3) Update the existing call record with status: inprogress. End.
      # 4) Create the call record like how it is now:

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
      else
        @call.status = params[:CallStatus]
        @call.save
      end
    else
      render :xml => {status: "Call request ID not found"}, status: 401
    end
  end
end
