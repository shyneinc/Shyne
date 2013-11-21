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
  #schdule reminder

  # def send_status
  #   twelve_hours = 12.hours.from_now
  #   four_hours = 4.hours.from_now
  #   one_hour = 1.hour.from_now
  #   sched = owner.scheduled_at

  #   if sched > twelve_hours
  #     # :run_at => Proc.new { 12.hours.from_now }
  #     CallRequestMailer.delay(run_at: 12.hours.from_now).request_approved(owner)
  #   elsif sched < twelve_hours && sched > four_hours
  #     CallRequestMailer.delay(run_at: 4.houts.from_now).request_approved(owner)
  #   elsif sched < four_hours && sched > one_hour
  #     CallRequestMailer.delay(run_at: 1.hour.from_now).request_approved(owner)
  #   else
  #     CallRequestMailer.request_approved(owner)
  #   end
  # end
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
