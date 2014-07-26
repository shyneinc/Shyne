require 'icalendar/tzinfo'

module Ical::Reminder
  extend ActiveSupport::Concern
  include Icalendar

  def self.post(options = {}, email)
    if !options.empty? && email != nil
      cal = Calendar.new
      utc_date = options[:utc_date]
      date = options[:date].to_datetime
      shortdate = date.to_s(:short)
      tzid = ActiveSupport::TimeZone.find_tzinfo(options[:timezone]).name
      tz = TZInfo::Timezone.get(tzid)
      timezone = tz.ical_timezone(date)
      cal.add(timezone)

      cal.event do
        dtstart     utc_date.iso8601
        dtend       utc_date.iso8601
        summary     "Call Scheduled with #{options[:guest]}"
        location    "#{Phony.normalize(ENV['TWILIO_NUMBER']).phony_formatted(:normalize => :US, :format => :international, :spaces => '-')}, Passcode:#{options[:passcode]}"
        description "Shyne: you have a scheduled call with #{options[:guest]} at #{shortdate}. Passcode: #{options[:passcode]}"
        klass       "PRIVATE"

        alarm do
          action        "EMAIL"
          description   "You have a schedule call with #{options[:guest]} at #{shortdate}. Passcode: #{options[:passcode]}" # email body (required)
          summary       "Shyne: Call Reminder"
          attendees     "#{email}"
          trigger       "-PT15M" # 15 minutes before
        end

        alarm do
          action        "EMAIL"
          description   "You have a schedule call with #{options[:guest]} at #{shortdate}. Passcode: #{options[:passcode]}" # email body (required)
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