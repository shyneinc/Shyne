module Ical::Reminder
  extend ActiveSupport::Concern
  include Icalendar

  def self.post(options = {}, email)
    if options.is_a?(Hash)
      cal = Calendar.new

      cal.event do
        dtstart     "#{options[:date]}"  
        dtend       "#{options[:date]}"
        summary     "Scheduled call with #{options[:mentor]}"
        description "Shyne: you have a scheduled call with #{options[:mentor]} at #{options[:date]}"
        klass       "PRIVATE"

        alarm do
          action        "EMAIL"
          description   "You have a schedule call with #{options[:mentor]} at #{options[:date]}. Passcode: #{options[:passcode]}" # email body (required)
          summary       "Shyne: Call Reminder"        # email subject (required)
          attendees     "mailto:#{email}" 
          trigger       "-PT15M" # 15 minutes before
        end

        alarm do
          action        "EMAIL"
          description   "You have a schedule call with #{options[:mentor]} at #{options[:date]}. Passcode: #{options[:passcode]}" # email body (required)
          summary       "Shyne: Call Reminder"        # email subject (required)
          attendees     "mailto:#{email}" 
          trigger       "-PT5M" # 15 minutes before
        end
      end
    end
  end

  def test
    "test this is"
  end
end