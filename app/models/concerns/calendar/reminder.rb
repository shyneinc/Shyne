module Calendar::Reminder
  include 'Icalendar'

  def self.send(option={} , email)
    cal = Calendar.new

    cal.event do
      dtstart       #appointment date
      dtend         #apppintment date
      summary     "Scheduled call with #{mentor}"
      description "Shyn: you have a scheduled call with #{mentor} at #{date}"
      klass       "PRIVATE"

      alarm do
        action        "EMAIL"
        description   "You have a schedule call with #{mentor} at #{date}. Passcode: #{passcode}" # email body (required)
        summary       "Shyne: Call Reminder"        # email subject (required)
        attendees     "mailto:#{email}" 
        trigger       "-PT15M" # 15 minutes before
      end

      alarm do
        action        "EMAIL"
        description   "You have a schedule call with #{mentor} at #{date}. Passcode: #{passcode}" # email body (required)
        summary       "Shyne: Call Reminder"        # email subject (required)
        attendees     "mailto:#{email}" 
        trigger       "-PT5M" # 15 minutes before
      end
    end
  end
end