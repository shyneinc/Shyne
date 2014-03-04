class MentorMailer < ActionMailer::Base
  default from: "Shyne@shyne.io"

  def approval_email(mentor)
    @mentor = mentor
    mail(to: mentor.user.email, subject: "You have been approved to be a mentor on Shyne!")
  end

  def declined_email(mentor)
    @mentor = mentor
    mail(to: mentor.user.email, subject: "Your application for Shyne has been declined")
  end
end
