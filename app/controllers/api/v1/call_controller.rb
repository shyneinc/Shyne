#twilio call handler
class Api::V1::CallController < ActionController::Base
  require 'nokogiri'
  respond_to :xml
  protect_from_forgery :except => ["finish"]

  def initiate
    @response = Twilio::TwiML::Response.new do |r|
      r.Gather action: api_call_start_url, method: 'GET', numDigits: 5, timeout: 10 do |f|
        f.Say "Greetings! Welcome to Shyne!", voice: 'alice'
        f.Say "Enter Passcode:", voice: 'alice'
      end
    end

    render :xml => Nokogiri::XML(@response.text)
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

      @call_request.call.create(phone_number: @caller_number, sid: @sid, status: :inprogress)
    else
      @response = Twilio::TwiML::Response.new do |r|
        r.Say "I'm sorry your passcode in invalid", voice: 'alice'
      end
    end

    render :xml => Nokogiri::XML(@response.text)
  end

  def finish
    @call = Call.find_by sid: params[:CallSid]

    if @call && params[:CallStatus] == "completed"

      @call.conferencesid = params[:ConferenceSid]
      @call.status = :completed
      @call.save
      @call.delay({:run_at => 3.minutes.from_now}).send_billing

      render :xml => {status: @call.status.to_s}, status: 200
    else
      render :xml => {status: "Call request ID not found"}, status: 401
    end
  end
end
