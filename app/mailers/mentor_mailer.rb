class MentorMailer < ActionMailer::Base
  default from: "Shyne <no-reply@shyne.io>"

  def approval_email(mentor)
    @mentor = mentor
    mail(to: mentor.user.email, subject: "You've been approved to be a Mentor on Shyne!")
  end

  def declined_email(mentor)
    @mentor = mentor
    mail(to: mentor.user.email, subject: "Your Mentor application for Shyne was declined")
  end
end
