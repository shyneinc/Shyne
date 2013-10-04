class MentorMailer < ActionMailer::Base
  default from: "no-reply@shyne.io"

  def approval_email(mentor)
    @mentor = mentor
    mail(to: mentor.user.email, subject: "You just got approved!")
  end
end
