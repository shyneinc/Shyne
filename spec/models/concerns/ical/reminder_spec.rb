require 'spec_helper'
require 'rspec_api_documentation/dsl'

describe "ReminderSpec" do
	let(:call_request) { create(:call_request) }
	describe "#post" do
		it "returns an object" do
			expect(Ical::Reminder.post({passcode: call_request.passcode, mentor: call_request.mentor.full_name, date: call_request.scheduled_at }, call_request.member.email )).to_not eql nil
	  end
	  it "return an ical class" do
	  	expect(Ical::Reminder.post({passcode: call_request.passcode, mentor: call_request.mentor.full_name, date: call_request.scheduled_at }, call_request.member.email ).class).to eql String
	  end
	  it "return nil if no email(2nd argument)" do 
	  	expect(Ical::Reminder.post({passcode: call_request.passcode, mentor: call_request.mentor.full_name, date: call_request.scheduled_at })).to eql nil  #I thinking of raising errors rather than returning nils
	  end
	  it "return nil if no options(1st argument)" do 
	  	expect(Ical::Reminder.post( call_request.member.email )).to eql nil #I thinking of raising errors rather than returning nils
	  end
	end
end