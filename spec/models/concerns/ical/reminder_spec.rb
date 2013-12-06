require 'spec_helper'
require 'rspec_api_documentation/dsl'

describe "ReminderSpec" do
	describe "#post" do
		it "returns an object" do
			expect(Ical::Reminder.post({passcode: "12345", mentor: "John Doe", date: DateTime.now + 2.days }, "test@email.com")).to_not eql nil
	  end
	  it "return an ical" do
	  	#checks if ical format is in the string
	  	expect(Ical::Reminder.post({passcode: "12345", mentor: "John Doe", date: DateTime.new + 2.days }, "test@email.com" )).to include("BEGIN:VCALENDAR" , "END:VCALENDAR")
	  end
	  it "raise error if no email(2nd argument)" do 
	  	lambda { Ical::Reminder.post({passcode: "12345", mentor: "John Doe", date: "test@email.com"}) }.should raise_error
	  end
	  it "raise an error if no options(1st argument)" do 
	  	lambda { Ical::Reminder.post( "test@email.com" ) }.should raise_error
	  end
	end
end