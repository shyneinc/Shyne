class CallRequestStatus < ClassyEnum::Base
  def send_status
    false
  end
end

class CallRequestStatus::Proposed < CallRequestStatus
  def send_status
    CallRequestMailer.delay.request_proposed(owner)
  end
end

class CallRequestStatus::Scheduled < CallRequestStatus
  def send_status
    CallRequestMailer.delay.request_approved(owner)
  end
end

class CallRequestStatus::Rescheduled < CallRequestStatus
  def send_status
    CallRequestMailer.delay.request_changed(owner)
  end
end
