require 'icalendar'
require 'date'

include Icalendar # You should do this in your class to limit namespace overlap

class CallRequestMailer < ActionMailer::Base
  default from: "Shyne <no-reply@shyne.io>"

  def request_proposed(call_request)
    @member = call_request.member
    @mentor = call_request.mentor
    @call_request = call_request

    mail(to: @mentor.email, subject: "You've received a Call Request!" )
  end

  def request_approved_mentor(call_request)
    @member = call_request.member
    @mentor = call_request.mentor
    @call_request = call_request
    @date = call_request.scheduled_at.in_time_zone(call_request.mentor.user.time_zone)
    @passcode = call_request.passcode

#     cal = Ical::Reminder.post({date: @date, passcode: @passcode, mentor: @mentor.full_name}, @member.email)
#
#     mail(to: @member.email, cc: @mentor.email, subject: "Call with #{@mentor.user.first_name} scheduled for #{call_request.scheduled_date}" ) do |format|
#       format.ics{
#         render :text => cal, :layout => false
#       }
#     end
    mail(to: @member.email, cc: @mentor.email, subject: "Call with #{@mentor.user.first_name} scheduled for #{call_request.scheduled_date}" )
  end

  def request_approved_member(call_request)
    @member = call_request.member
    @mentor = call_request.mentor
    @call_request = call_request
    @date = call_request.scheduled_at.in_time_zone(call_request.mentor.user.time_zone)
    @passcode = call_request.passcode

#     cal = Ical::Reminder.post({date: @date, passcode: @passcode, mentor: @mentor.full_name}, @member.email)
#
#     mail(to: @member.email, cc: @mentor.email, subject: "Call with #{@mentor.user.first_name} scheduled for #{call_request.scheduled_date}" ) do |format|
#       format.ics{
#         render :text => cal, :layout => false
#       }
#     end
    mail(to: @mentor.email, cc: @member.email, subject: "Call with #{@member.user.first_name} scheduled for #{call_request.scheduled_date}" )
  end

  def request_changed_mentor(call_request)
    @member = call_request.member
    @mentor = call_request.mentor
    @call_request = call_request

    mail(to: @member.email, cc: @mentor.email, subject: "#{@mentor.user.first_name} suggested another time for your Call Request" )
  end

  def request_changed_member(call_request)
    @member = call_request.member
    @mentor = call_request.mentor
    @call_request = call_request

    mail(to: @mentor.email, cc: @member.email, subject: "#{@member.user.first_name} suggested another time for your Call Request" )
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

  def request_declined_mentor(call_request)
    @member = call_request.member
    @mentor = call_request.mentor
    @call_request = call_request

    mail(to: @member.email, cc: @mentor.email, subject: "Call with #{@mentor.user.first_name} was declined" )
  end

  def request_declined_member(call_request)
    @member = call_request.member
    @mentor = call_request.mentor
    @call_request = call_request

    mail(to: @mentor.email, cc: @member.email, subject: "Call with #{@member.user.first_name} was declined" )
  end

  def request_cancelled_mentor(call_request)
    @member = call_request.member
    @mentor = call_request.mentor
    @call_request = call_request

    mail(to: @member.email, cc: @mentor.email, subject: "Call Cancelled" )
  end

  def request_cancelled_member(call_request)
    @member = call_request.member
    @mentor = call_request.mentor
    @call_request = call_request

    mail(to: @mentor.email, cc: @member.email, subject: "Call Cancelled" )
  end
end
