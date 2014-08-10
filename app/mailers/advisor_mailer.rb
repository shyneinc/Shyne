class AdvisorMailer < ActionMailer::Base
  default from: "Shyne <no-reply@shyne.io>"

  def approval_email(advisor)
    @advisor = advisor
    mail(to: advisor.user.email, subject: "You've been approved to be an Advisor on Shyne!")
  end

  def declined_email(advisor)
    @advisor = advisor
    mail(to: advisor.user.email, subject: "Your Advisor application for Shyne was declined")
  end
end
