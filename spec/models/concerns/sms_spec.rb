require 'spec_helper'
require 'rspec_api_documentation/dsl'

describe "SmsConcern" do
	
	# it will get **Net::OpenTimeout** if no internet
  describe "#send" do
  	it "should send sms to valid number" do
  		#international format phone number
  		expect(Twilio::Sms.send("hello there!" , "+19099739129")).to eql(true)
  		#non-international format is fine
  		expect(Twilio::Sms.send("hello there!" , "9099739129")).to eql(true)
  	end

  	it "should not send to invalid number" do
  		lambda{ Twilio::Sms.send("hello there!" , "99739129") }.should raise_error
  	end

  	it "should take 2 arguments" do
  		lambda{ Twilio::Sms.send("99739129") }.should raise_error 	
  		lambda{ Twilio::Sms.send("hello there!" , "9099739129") }.should_not raise_error
  	end 
  end

  describe "#send_approval" do
  	it "should take a valid number as an argument" do
  		#international format phone number
  		expect(Twilio::Sms.send_approval("+19099739129")).to eql(true)
  		#non-international format is fine
  		expect(Twilio::Sms.send_approval("9099739129")).to eql(true)
  	end
  end

  describe "#send_request" do
  	it "should take a valid number as an argument" do
  		#international format phone number
  		expect(Twilio::Sms.send_request("+19099739129")).to eql(true)
  		#non-international format is fine
  		expect(Twilio::Sms.send_request("9099739129")).to eql(true)
  	end
  end
end