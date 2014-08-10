class CallRequestStatus < ClassyEnum::Base
  def send_status
    false
  end
end

class CallRequestStatus::Proposed < CallRequestStatus
  def send_status
    CallRequestMailer.delay.request_proposed(owner)
    #Twilio::Sms.delay.send_sms("You have a new call request!", owner.advisor.phone_number.to_s)
  end
end

class CallRequestStatus::ApprovedMember < CallRequestStatus
  def send_status
    CallRequestMailer.delay.send_approval_email_to_member(owner)
    CallRequestMailer.delay.send_approval_email_to_advisor(owner)
    #Twilio::Sms.delay.send_sms("Your call request is approved!", owner.member.phone_number.to_s)
  end
end

class CallRequestStatus::ApprovedAdvisor < CallRequestStatus
  def send_status
    CallRequestMailer.delay.send_approval_email_to_member(owner)
    CallRequestMailer.delay.send_approval_email_to_advisor(owner)
    #Twilio::Sms.delay.send_sms("Your call request is approved!", owner.advisor.phone_number.to_s)
  end
end

class CallRequestStatus::ChangedAdvisor < CallRequestStatus
  def send_status
    CallRequestMailer.delay.request_changed_advisor(owner)
    #Twilio::Sms.delay.send_sms("Your call request has been changed.", owner.member.phone_number.to_s)
  end
end

class CallRequestStatus::ChangedMember < CallRequestStatus
  def send_status
    CallRequestMailer.delay.request_changed_member(owner)
    #Twilio::Sms.delay.send_sms("Your call request has been changed.", owner.advisor.phone_number.to_s)
  end
end

class CallRequestStatus::DeclinedAdvisor < CallRequestStatus
  def send_status
    CallRequestMailer.delay.request_declined_advisor(owner)
  end
end

class CallRequestStatus::DeclinedMember < CallRequestStatus
  def send_status
    CallRequestMailer.delay.request_declined_member(owner)
  end
end

class CallRequestStatus::CancelledAdvisor < CallRequestStatus
  def send_status
    CallRequestMailer.delay.request_cancelled_advisor(owner)
  end
end

class CallRequestStatus::CancelledMember < CallRequestStatus
  def send_status
    CallRequestMailer.delay.request_cancelled_member(owner)
  end
end

class CallRequestStatus::Completed < CallRequestStatus
  def send_status
    CallRequestMailer.delay.send_call_summary_to_advisor(owner)
    CallRequestMailer.delay.send_call_summary_to_member(owner)
  end
end

class CallRequestStatus::ProcessedMember < CallRequestStatus
  def send_status
    if owner.advisor.balanced_customer.bank_accounts.none?
      CallRequestMailer.delay.send_bank_reminder_to_advisor(owner)
    end
  end
end

class CallRequestStatus::ProcessedAdvisor < CallRequestStatus
  def send_status
    #Do nothing
  end
end

class CallRequestStatus::Processed < CallRequestStatus
  def send_status
    #Do nothing
  end
end