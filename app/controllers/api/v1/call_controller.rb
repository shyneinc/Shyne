#twilio call handler
class Api::V1::CallController < ActionController::Base
  require 'nokogiri'
  respond_to :xml

  def initiate
    @response = Twilio::TwiML::Response.new do |r|
      r.Gather action: api_call_start_url, method: :post, numDigits: 5, timeout: 10 do |f|
        f.Say "Hello! Welcome to Shyne!", voice: 'alice'
        f.Say "Please enter the passcode given in your confirmation email:", voice: 'alice'
      end
    end

    render :xml => Nokogiri::XML(@response.text), status: 200
  end

  def start
    #TODO: Make sure people don't try to call-in before the scheduled time or tell them to call back later
    @call_request = CallRequest.find_by passcode: params[:Digits], status: [:approved_member, :approved_mentor]
    @caller_number = params[:From]
    @sid = params[:CallSid]

    if @call_request
      @response = Twilio::TwiML::Response.new do |r|
        r.Say "Entering conference!", voice: 'alice'
        r.Dial action: api_call_finish_url, method: :post do |d|
          d.Conference @call_request.passcode.to_s, maxParticipants: 2
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
      if params[:CallStatus] == "completed" || params[:CallStatus] == "in-progress" #Why is in-progesss = completed?
        @call.conferencesid = params[:ConferenceSid]
        @call.status = :completed
        @call.save

        @response = Twilio::TwiML::Response.new do |r|
          r.Say "Thank you for using Shyne, Goodbye!", voice: 'alice'
          r.Hangup
        end

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
