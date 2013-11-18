require 'icalendar'
require 'date'

include Icalendar # You should do this in your class to limit namespace overlap

class CallRequestMailer < ActionMailer::Base
  default from: "no-reply@shyne.io"

  def request_proposed(call_request)
    @member = call_request.member
    @mentor = call_request.mentor
    @call_request = call_request

    mail(to: @mentor.email, cc: @member.email, subject: "Call request have been proposed!" )
  end

  def request_approved(call_request)
    @member = call_request.member
    @mentor = call_request.mentor
    @call_request = call_request

    cal = Calendar.new
    cal.event do
      dtstart     call_request.scheduled_at
      dtend       call_request.scheduled_at+1.hour
      summary     "Shyne Call"
      description "Call with #{@member.full_name} and #{@mentor.full_name}"
      klass       "PRIVATE"
    end
    attachments['event.ics'] = cal.to_ical

    mail(to: @member.email, cc: @mentor.email, subject: "Call request have been approved!" )
  end

  def request_changed(call_request)
    @member = call_request.member
    @mentor = call_request.mentor
    @call_request = call_request
    
    mail(to: @member.email, cc: @mentor.email, subject: "Schedule change has been proposed!" )
  end

  def send_reminder(call_request)
    @member = call_request.member
    @mentor = call_request.mentor
    @call_request = call_request
    
    mail(to: @mentor.email, cc: @member.email, subject: "Reminder for your scheduled call" )
  end

  def request_completed(call_request)
    @member = call_request.member
    @mentor = call_request.mentor
    @call_request = call_request
    
    mail(to: @mentor.email, subject: "Summary of your call with #{@member.full_name}")
    mail(to: @member.email, subject: "Summary of your call with #{@mentor.full_name}")
  end
end
