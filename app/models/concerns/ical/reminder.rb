module Ical::Reminder
  extend ActiveSupport::Concern
  include Icalendar

  def self.post(options = {}, email)
    if !options.empty? && email != nil
      cal = Calendar.new
      date = options[:date].to_datetime
      shortdate = options[:date].to_s(:short)

      cal.event do
        dtstart     date.utc
        dtend       date.utc
        summary     "Call Scheduled with #{options[:mentor]}"
        location    "#{Phony.normalize(ENV['TWILIO_NUMBER']).phony_formatted!(:normalize => :US, :format => :international, :spaces => '-')}, Passcode:#{options[:passcode]}"
        description "Shyne: you have a scheduled call with #{options[:mentor]} at #{shortdate}. Passcode: #{options[:passcode]}"
        klass       "PRIVATE"

        alarm do
          action        "EMAIL"
          description   "You have a schedule call with #{options[:mentor]} at #{shortdate}. Passcode: #{options[:passcode]}" # email body (required)
          summary       "Shyne: Call Reminder"
          attendees     "#{email}"
          trigger       "-PT15M" # 15 minutes before
        end

        alarm do
          action        "EMAIL"
          description   "You have a schedule call with #{options[:mentor]} at #{shortdate}. Passcode: #{options[:passcode]}" # email body (required)
          summary       "Shyne: Call Reminder"
          attendees     "#{email}"
          trigger       "-PT5M" # 15 minutes before
        end
      end

      cal.publish
      cal.to_ical
    else
      raise ArgumentError, "Wrong Parameters"
    end

  end
end