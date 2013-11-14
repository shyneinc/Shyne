class CallMailer < ActionMailer::Base
  default from: "no-reply@shyne.io"

  def request_proposed(member, mentor, call_request)
    @member = member
    @mentor = mentor
    @call_request = call_request
    mail(to: mentor.email, cc: member.email, subject: "Call Request have been proposed!" )
  end

  def request_approved(member, mentor, call_request)
    @member = member
    @mentor = mentor
    @call_request = call_request
    mail(to: member.email, cc: mentor.email, subject: "Call Request have been approved!" )
  end

  def request_changed(member, mentor, call_request)
    @member = member
    @mentor = mentor
    @call_request = call_request
    mail(to: member.email, cc: mentor.email, subject: "Schedule change has been proposed!" )
  end

  def send_reminder(member, mentor, call_request)
    @member = member
    @mentor = mentor
    @call_request = call_request
    mail(to: mentor.email, cc: member.email, subject: "Call Reuest have been proposed!" )
  end

  def send_duration(member, mentor, call_request)
    @member = member
    @mentor = mentor
    @call_request = call_request
    mail(to: mentor.email, subject: "Duration for you call with #{member.full_name}" )
  end

  def send_bill(member, mentor, call_request)
    @member = member
    @mentor = mentor
    @call_request = call_request
    mail(to: member.email, subject: "Bill for you call with #{mentor.full_name}")
  end
end
