class CallRequestStatus < ClassyEnum::Base
  def send_status
    false
  end
end

class CallRequestStatus::Proposed < CallRequestStatus
  def send_status
    CallRequestMailer.delay.request_proposed(owner)
    Twilio::Sms.delay.send_sms("Your have a new call request!", owner.mentor.phone_number.to_s)
  end
end

class CallRequestStatus::ApprovedMember < CallRequestStatus
  def send_status
    CallRequestMailer.delay.send_approval_email_to_member(owner)
    CallRequestMailer.delay.send_approval_email_to_mentor(owner)
    Twilio::Sms.delay.send_sms("Your call request is approved!", owner.member.phone_number.to_s)
  end
end

class CallRequestStatus::ApprovedMentor < CallRequestStatus
  def send_status
    CallRequestMailer.delay.send_approval_email_to_member(owner)
    CallRequestMailer.delay.send_approval_email_to_mentor(owner)
    Twilio::Sms.delay.send_sms("Your call request is approved!", owner.mentor.phone_number.to_s)
  end
end

class CallRequestStatus::ChangedMentor < CallRequestStatus
  def send_status
    CallRequestMailer.delay.request_changed_mentor(owner)
    Twilio::Sms.delay.send_sms("Your call request has been changed.", owner.member.phone_number.to_s)
  end
end

class CallRequestStatus::ChangedMember < CallRequestStatus
  def send_status
    CallRequestMailer.delay.request_changed_member(owner)
    Twilio::Sms.delay.send_sms("Your call request has been changed.", owner.mentor.phone_number.to_s)
  end
end

class CallRequestStatus::DeclinedMentor < CallRequestStatus
  def send_status
    CallRequestMailer.delay.request_declined_mentor(owner)
  end
end

class CallRequestStatus::DeclinedMember < CallRequestStatus
  def send_status
    CallRequestMailer.delay.request_declined_member(owner)
  end
end

class CallRequestStatus::CancelledMentor < CallRequestStatus
  def send_status
    CallRequestMailer.delay.request_cancelled_mentor(owner)
  end
end

class CallRequestStatus::CancelledMember < CallRequestStatus
  def send_status
    CallRequestMailer.delay.request_cancelled_member(owner)
  end
end

class CallRequestStatus::Completed < CallRequestStatus
  def send_status
    CallRequestMailer.delay.request_completed_mentor(owner)
    CallRequestMailer.delay.request_completed_member(owner)
    Twilio::Sms.delay.send_sms("Your call is completed!", owner.member.phone_number.to_s)
  end
end

class CallRequestStatus::Processed < CallRequestStatus
  def send_status
    CallRequestMailer.delay.request_processed(owner)
  end
end