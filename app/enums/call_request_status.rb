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

class CallRequestStatus::Approved < CallRequestStatus
  def send_status
    12_hours = 12.hours.from_now
      4_hours = 4.hours.from_now
      1_hour = 1.hour.from_now
      sched = owner.scheduled_at

    if sched > 12_hours
      # :run_at => Proc.new { 12.hours.from_now }
      CallRequestMailer.delay(run_at: 12.hours.from_now).request_approved(owner)
    elsif sched < 12_hours && sched > 4_hours
      CallRequestMailer.delay(run_at: 4.houts.from_now).request_approved(owner)
    elsif sched < 4_hours && sched > 1_hour
      CallRequestMailer.delay(run_at: 1.hour.from_now).request_approved(owner)
    else
      CallRequestMailer.request_approved(owner)
    end
  end
end

class CallRequestStatus::Changed < CallRequestStatus
  def send_status
    CallRequestMailer.delay.request_changed(owner)
  end
end

class CallRequestStatus::Completed < CallRequestStatus
  def send_status
    CallRequestMailer.delay.request_completed(owner)
  end
end
