module Ical::Reminder
  extend ActiveSupport::Concern
  include Icalendar

  def self.post(options = {}, email)
    if options.is_a?(Hash)
      cal = Calendar.new
      date = options[:date].to_datetime

      cal.event do
        dtstart     date.utc 
        dtend       date.utc
        summary     "Scheduled call with #{options[:mentor]}"
        description "Shyne: you have a scheduled call with #{options[:mentor]} at #{date.to_s(:long)}. Passcode: #{options[:passcode]}"
        klass       "PRIVATE"

        alarm do
          action        "EMAIL"
          description   "You have a schedule call with #{options[:mentor]} at #{date.to_s(:long)}. Passcode: #{options[:passcode]}" # email body (required)
          summary       "Shyne: Call Reminder"        # email subject (required)
          attendees     "mailto:#{email}" 
          trigger       "-PT15M" # 15 minutes before
        end

        alarm do
          action        "EMAIL"
          description   "You have a schedule call with #{options[:mentor]} at #{date.to_s(:long)}. Passcode: #{options[:passcode]}" # email body (required)
          summary       "Shyne: Call Reminder"        # email subject (required)
          attendees     "mailto:#{email}" 
          trigger       "-PT5M" # 15 minutes before
        end
      end

      cal.publish
      cal.to_ical
    end
  end
end