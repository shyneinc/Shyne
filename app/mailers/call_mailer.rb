class CallMailer < ActionMailer::Base
  default from: "no-reply@shyne.io"

  def request_proposed(member, mentor, call_request)
    @member = member
    @mentor = mentor
    @call_request = call_request
    mail(to: mentor.user.email, cc: member.user.email, subject: "Call Request have been proposed!" )
  end

  def request_approved(member, mentor, call_request)
    @member = member
    @mentor = mentor
    @call_request = call_request
    mail(to: member.user.email, cc: mentor.user.email, subject: "Call Request have been approved!" )
  end

  def request_changed(member, mentor, call_request)
    @member = member
    @mentor = mentor
    @call_request = call_request
    mail(to: member.user.email, cc: mentor.user.email, subject: "Schedule change has been proposed!" )
  end

  def send_reminder(member, mentor, call_request)
    @member = member
    @mentor = mentor
    @call_request = call_request
    mail(to: mentor.user.email, cc: member.user.email, subject: "Call Reuest have been proposed!" )
  end

  def send_duration(member, mentor, call)
    @member = member
    @mentor = mentor
    @call = call
    mail(to: mentor.user.email, cc: member.user.email, subject: "Call Reuest have been proposed!" )
  end
end
