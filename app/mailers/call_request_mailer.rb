require 'icalendar'
require 'date'

include Icalendar # You should do this in your class to limit namespace overlap

class CallRequestMailer < ActionMailer::Base
  default from: "no-reply@shyne.io"

  def request_proposed(call_request)
    @member = call_request.member
    @mentor = call_request.mentor
    @call_request = call_request

    mail(to: @mentor.email, cc: @member.email, subject: "Shyne: You've received a Call Request!" )
  end

  def request_approved(call_request)
    @member = call_request.member
    @mentor = call_request.mentor
    @call_request = call_request
    @date = call_request.scheduled_at
    @passcode = call_request.passcode

    cal = Ical::Reminder.post({date: @date, passcode: @passcode, mentor: @mentor.full_name}, @member.email)

    mail(to: @member.email, cc: @mentor.email, subject: "Call with #{@mentor.user.first_name} scheduled on #{call_request.scheduled_at.strftime("%a, %b %d")} at #{call_request.scheduled_at.strftime("%H:%M%p")}" ) do |format|
      format.ics{
        render :text => cal, :layout => false
      }
    end
  end

  def request_changed(call_request)
    @member = call_request.member
    @mentor = call_request.mentor
    @call_request = call_request

    mail(to: @member.email, cc: @mentor.email, subject: "#{@mentor.user.first_name} suggested another time for your call request" )
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
  end

  def request_processed(call_request)
    @member = call_request.member
    @mentor = call_request.mentor
    @call_request = call_request

    mail(to: @mentor.email, subject: "Payment has been processed for your call with #{@member.full_name}")
  end

  def request_declined(call_request)
    @member = call_request.member
    @mentor = call_request.mentor
    @call_request = call_request

    mail(to: @member.email, cc: @mentor.email, subject: "Call with #{@mentor.user.first_name} was declined" )
  end

  def request_cancelled(call_request)
    @member = call_request.member
    @mentor = call_request.mentor
    @call_request = call_request

    mail(to: @member.email, cc: @mentor.email, subject: "Shyne: Call Cancelled" )
  end
end
