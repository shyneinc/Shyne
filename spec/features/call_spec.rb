require 'spec_helper'
require 'twilio-test-toolkit'

describe "CallController" do
  let(:call_request) { create(:call_request, :status => CallRequestStatus::ApprovedMentor.new) }
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
        expect(gather).to have_say("Hello! Welcome to Shyne!")
        expect(gather).to have_say("Please enter the passcode given in your confirmation email:")
      end
    end

    it "has a gather action" do
      call.within_gather do |gather|
        expect(gather.gather_action).to eql api_call_start_url
      end
    end
  end

  describe "#start" do
    it "enters conference" do
      call.within_gather do |gather|
        gather.press(call_request.passcode)
        expect(call_request.calls.count).to eql 1
      end
    end
  end

  describe "#finish" do
    it "hangs up the call" do
      call.within_gather do |gather|
        gather.press(call_request.passcode)
        page.driver.browser.post api_call_finish_path, CallSid: call.sid, CallStatus: "completed"
        expect(page.body).to have_content "Thank you for using Shyne, Goodbye!"
      end
    end
  end
end