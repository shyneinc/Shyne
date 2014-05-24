require 'spec_helper'
require 'rspec_api_documentation/dsl'

describe "SmsConcern" do

  # it will get **Net::OpenTimeout** if no internet
  describe "#send_sms" do
    it "returns a resource object" do
      expect(Twilio::Sms.send_sms("hello there!", "+19099739129").body).to_not eql nil
    end

    it "sends an sms to an international number" do
      expect(Twilio::Sms.send_sms("hello there!", "+19099739129").body).to eql("hello there!")
    end

    it "sends an sms to a non-international number" do
      expect(Twilio::Sms.send_sms("hello there!", "9099739129").body).to eql("hello there!")
    end

    it "raises an error if the number is invalid" do
      lambda { Twilio::Sms.send_sms("hello there!", "99739129") }.should raise_error
    end

    it "raises an error for invalid number of arguments" do
      lambda { Twilio::Sms.send_sms("99739129") }.should raise_error
    end
  end

  describe "#send_approval" do
    it "sends approval message" do
      expect(Twilio::Sms.send_approval("9099739129").body).to eql("Your call request has been approved!")
    end
  end

  describe "#send_request" do
    it "sends request message" do
      expect(Twilio::Sms.send_request("9099739129").body).to eql("You have a call request!")
    end
  end
end