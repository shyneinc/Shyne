class CallRequestStatus < ClassyEnum::Base
  include Sms
  
  def send_status
    false
  end
end

class CallRequestStatus::Proposed < CallRequestStatus
  def send_status
    CallRequestMailer.delay.request_proposed(owner)
    Sms.delay.send("Your have call request!" , owner.mentor.phone_number.to_s )
  end
end

class CallRequestStatus::Approved < CallRequestStatus
  def send_status
    CallRequestMailer.delay.request_approved(owner)
    Sms.delay.send("Your call request is approved!" , owner.member.phone_number.to_s )
  end
end

class CallRequestStatus::Changed < CallRequestStatus
  def send_status
    CallRequestMailer.delay.request_changed(owner)
    Sms.delay.send("Your call request is approved!" , owner.member.phone_number.to_s )
    Sms.delay.send("Your call request is approved!" , owner.mentor.phone_number.to_s )
  end
end

class CallRequestStatus::Completed < CallRequestStatus
  def send_status
    CallRequestMailer.delay.request_completed(owner)
    Sms.delay.send("Your call is completed!" , owner.member.phone_number.to_s )
  end
end
