class CallRequestStatus < ClassyEnum::Base
  def send_status
    false
  end
end

class CallRequestStatus::Proposed < CallRequestStatus
   def send_status
    CallMailer.request_proposed(owner.member, owner.mentor, owner).deliver
  end
end

class CallRequestStatus::Scheduled < CallRequestStatus
  def send_status
    CallMailer.request_approved(owner.member, owner.mentor, owner).deliver
  end
end

class CallRequestStatus::Rescheduled < CallRequestStatus
  def send_status
    CallMailer.request_changed(owner.member, owner.mentor, owner).deliver
  end
end
