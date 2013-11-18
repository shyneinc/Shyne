require 'spec_helper'
require 'twilio-test-toolkit'

describe "CallController" do
  let(:call_request) { FactoryGirl.create(:call_request, :status => :approved) }
  let(:call) { ttt_call(api_call_initiate_path, 11234567890, 19094804755) }

  describe "#initiate" do
    it "assigns the call" do
      expect(call).to_not be_nil
    end

    it "has a sid" do
      expect(call.sid).to_not be_blank
    end

    it "has a greeting" do
      call.within_gather do |gather|
        expect(gather).to have_say("Greetings! Welcome to Shyne!")
        expect(gather).to have_say("Enter Passcode:")
      end
    end

    it "has a gather action" do
      call.within_gather do |gather|
        expect(gather.gather_action).to eql api_call_start_url
      end
    end
  end

  describe "#start" do
    it "enters dojo" do
      call.within_gather do |gather|
        gather.press(call_request.passcode)
        expect(call_request.calls.count).to eql 1
      end
    end
  end

  describe "#finish" do
    pending
  end
end