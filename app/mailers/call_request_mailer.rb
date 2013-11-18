class CallRequestMailer < ActionMailer::Base
  default from: "no-reply@shyne.io"

  def request_proposed(call_request)
    @member = call_request.member
    @mentor = call_request.mentor
    @call_request = call_request
    
    mail(to: @mentor.email, cc: @member.email, subject: "Call Request have been proposed!" )
  end

  def request_approved(call_request)
    @member = call_request.member
    @mentor = call_request.mentor
    @call_request = call_request
    
    mail(to: @member.email, cc: @mentor.email, subject: "Call Request have been approved!" )
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
    
    mail(to: @mentor.email, cc: @member.email, subject: "Call Reuest have been proposed!" )
  end

  def request_completed(call_request)
    @member = call_request.member
    @mentor = call_request.mentor
    @call_request = call_request
    
    mail(to: @mentor.email, subject: "Duration for you call with #{@member.full_name}" )
    mail(to: @member.email, subject: "Bill for you call with #{@mentor.full_name}")
  end
end
