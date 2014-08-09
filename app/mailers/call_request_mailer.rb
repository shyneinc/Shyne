require 'icalendar'
require 'date'

include Icalendar # You should do this in your class to limit namespace overlap

class CallRequestMailer < ActionMailer::Base
  default from: "Shyne <no-reply@shyne.io>"

  def request_proposed(call_request)
    @member = call_request.member
    @advisor = call_request.advisor
    @call_request = call_request

    mail(to: @advisor.email, subject: "You've received a Call Request!" )
  end

  def send_approval_email_to_member(call_request)
    @member = call_request.member
    @advisor = call_request.advisor
    @call_request = call_request
    @date = call_request.scheduled_at.in_time_zone(call_request.member.user.time_zone)
    @passcode = call_request.passcode

    cal = Ical::Reminder.post({date: @date, timezone: @member.user.time_zone, passcode: @passcode, guest: @advisor.full_name}, @member.email)
    mail.attachments['event.ics'] = { :mime_type => 'text/calendar', :content => cal }

    mail(to: @member.email, subject: "Call with #{@advisor.user.first_name} scheduled for #{call_request.scheduled_date_member}")
  end

  def send_approval_email_to_advisor(call_request)
    @member = call_request.member
    @advisor = call_request.advisor
    @call_request = call_request
    @date = call_request.scheduled_at.in_time_zone(call_request.advisor.user.time_zone)
    @passcode = call_request.passcode

    cal = Ical::Reminder.post({date: @date, timezone: @advisor.user.time_zone, passcode: @passcode, guest: @member.full_name}, @advisor.email)
    mail.attachments['event.ics'] = { :mime_type => 'text/calendar', :content => cal }

    mail(to: @advisor.email, subject: "Call with #{@member.user.first_name} scheduled for #{call_request.scheduled_date}")
  end

  def request_changed_advisor(call_request)
    @member = call_request.member
    @advisor = call_request.advisor
    @call_request = call_request

    mail(to: @member.email, subject: "#{@advisor.user.first_name} suggested another time for your Call Request" )
  end

  def request_changed_member(call_request)
    @member = call_request.member
    @advisor = call_request.advisor
    @call_request = call_request

    mail(to: @advisor.email, subject: "#{@member.user.first_name} suggested another time for your Call Request" )
  end

  def send_reminder(call_request)
    @member = call_request.member
    @advisor = call_request.advisor
    @call_request = call_request

    mail(to: @advisor.email, cc: @member.email, subject: "Reminder for your scheduled call" )
  end

  def send_call_summary_to_advisor(call_request)
    @member = call_request.member
    @advisor = call_request.advisor
    @call_request = call_request

    mail(to: @advisor.email, subject: "Summary for your call with #{@member.user.first_name}")
  end

  def send_call_summary_to_member(call_request)
    @member = call_request.member
    @advisor = call_request.advisor
    @call_request = call_request

    mail(to: @member.email, subject: "Summary for your call with #{@advisor.user.first_name}")
  end

  def send_call_receipt_to_member(call_request)
    @member = call_request.member
    @advisor = call_request.advisor
    @call_request = call_request

    mail(to: @member.email, subject: "Receipt for your call with #{@advisor.user.first_name}")
  end

  def send_call_income_to_advisor(call_request)
    @member = call_request.member
    @advisor = call_request.advisor
    @call_request = call_request

    mail(to: @advisor.email, subject: "Income for your call with #{@member.user.first_name}")
  end

  def send_bank_reminder_to_advisor(call_request)
    @member = call_request.member
    @advisor = call_request.advisor
    @call_request = call_request

    mail(to: @advisor.email, subject: "It's time to get paid! Please link bank account" )
  end

  def request_declined_advisor(call_request)
    @member = call_request.member
    @advisor = call_request.advisor
    @call_request = call_request

    mail(to: @member.email, subject: "Call with #{@advisor.user.first_name} was declined" )
  end

  def request_declined_member(call_request)
    @member = call_request.member
    @advisor = call_request.advisor
    @call_request = call_request

    mail(to: @advisor.email, subject: "Call with #{@member.user.first_name} was declined" )
  end

  def request_cancelled_advisor(call_request)
    @member = call_request.member
    @advisor = call_request.advisor
    @call_request = call_request

    mail(to: @member.email, subject: "Call Cancelled" )
  end

  def request_cancelled_member(call_request)
    @member = call_request.member
    @advisor = call_request.advisor
    @call_request = call_request

    mail(to: @advisor.email, subject: "Call Cancelled" )
  end
end
