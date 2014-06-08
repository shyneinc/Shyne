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
    CallRequestMailer.delay.send_call_summary_to_mentor(owner)
    CallRequestMailer.delay.send_call_summary_to_member(owner)
  end
end

class CallRequestStatus::ProcessedMember < CallRequestStatus
  def send_status
    CallRequestMailer.delay.send_call_receipt_to_member(owner)

    if owner.mentor.balanced_customer.bank_accounts.none?
      CallRequestMailer.delay.send_bank_reminder_to_mentor(owner)
    end
  end
end

class CallRequestStatus::ProcessedMentor < CallRequestStatus
  def send_status
    CallRequestMailer.delay.send_call_income_to_mentor(owner)
  end
end

class CallRequestStatus::Processed < CallRequestStatus
  def send_status
    CallRequestMailer.delay.send_call_receipt_to_member(owner)
    CallRequestMailer.delay.send_bank_reminder_to_mentor(owner)
  end
end