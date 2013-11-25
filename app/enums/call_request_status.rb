class CallRequestStatus < ClassyEnum::Base
  def send_status
    false
  end
end

class CallRequestStatus::Proposed < CallRequestStatus
  def send_status
    CallRequestMailer.delay.request_proposed(owner)
    Twilio::Sms.delay.send("Your have a new call request!", owner.mentor.phone_number.to_s)
  end
end

class CallRequestStatus::Approved < CallRequestStatus
  def send_status
    CallRequestMailer.delay.request_approved(owner)
    Twilio::Sms.delay.send("Your call request is approved!", owner.member.phone_number.to_s)
  end
end

class CallRequestStatus::Changed < CallRequestStatus
  def send_status
    CallRequestMailer.delay.request_changed(owner)
    Twilio::Sms.delay.send("Your call request has been changed.", owner.member.phone_number.to_s)
  end
end

class CallRequestStatus::Completed < CallRequestStatus
  def send_status
    CallRequestMailer.delay.request_completed(owner)
    Twilio::Sms.delay.send("Your call is completed!", owner.member.phone_number.to_s)
  end
end

class CallRequestStatus::Processed < CallRequestStatus
  def send_status
    #CallRequestMailer.delay.request_processed(owner)
  end
end

