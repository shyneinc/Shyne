require 'spec_helper'
require 'rspec_api_documentation/dsl'

describe "ReminderSpec" do
  let(:call) { Ical::Reminder.post({passcode: "12345", timezone: "America/Chicago", guest: "John Doe", date: DateTime.now + 2.days}, "test@email.com") }
  describe "#post" do
    it "returns an object" do
      expect(call).to_not eql nil
    end
    it "is in icalendar format" do
      expect(call).to include("BEGIN:VCALENDAR", "END:VCALENDAR")
    end
    it "has an alarm" do
      expect(call).to include("BEGIN:VALARM", "END:VALARM")
    end
    it "has location" do
      expect(call).to include("#{Phony.normalize(ENV['TWILIO_NUMBER']).phony_formatted(:normalize => :US, :format => :international, :spaces => '-')}")
    end
    it "has passcode" do
      expect(call).to include("Passcode:12345")
    end
    it "should mention the mentor" do
      expect(call).to include("call with John Doe")
    end
    #i still need to test this because this is manually implemented and not coming from ruby
    it "raise error if wrong arguments" do
      lambda { Ical::Reminder.post({passcode: "12345", guest: "John Doe", date: DateTime.now}) }.should raise_error
    end
  end
end