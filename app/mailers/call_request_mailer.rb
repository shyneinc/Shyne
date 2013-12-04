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
    @date = call_request.scheduled_at
    @passcode = call_request.passcode

    cal = Ical::Reminder.post({date: @date.to_formatted_s(:long) , passcode: @passcode, mentor: @mentor.full_name}, @member.email)
    # attachments['ShyneCall.ics'] = {:mime_type => 'text/calendar' , :content => cal}
 
    mail(to: @member.email, cc: @mentor.email, subject: "Call request have been approved!" ) do |format|
      format.ics{
        render :text => cal, :layout => false
      }
    end
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
