require 'spec_helper'
require 'twilio-test-toolkit'

describe "Conference API" do
  describe "Initiate Call" do
    before(:all) do
      @call = ttt_call(api_conference_initiate_path, nil, 19094804755, {:method => :get})
    end

    it "assigns the call" do
      expect(@call).to_not be_nil
    end

    it "has a sid" do
      expect(@call.sid).to_not be_blank
    end

    it "has a greeting" do
      @call.within_gather do |gather|
        expect(gather).to have_say("Greetings! Welcome to Shyne!")
        expect(gather).to have_say("Enter Passcode:")
      end
    end

    it "has a gather action" do
      @call.within_gather do |gather|
        expect(gather.gather_action).to eql api_conference_start_url
      end
    end
  end
end