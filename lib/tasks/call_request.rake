namespace :call_request  do
  desc "Calculate billable duration of the call request"
  task :calculate_billable_duration => :environment do
    CallRequest.where(billable_duration: nil, status: :approved).find_each do |call_request|
      call_request.calculate_billable_duration
    end
  end

  task :send_reminders => :environment do
    CallRequest.where(billable_duration: nil, status: :approved).find_each do |call_request|
      #TODO: See if we can achieve the same thing with icalendar alaram
      #if call_request.scheduled_at > 12.hours.from_now
      #  CallRequestMailer.delay.remind(call_request)
      #elsif call_request.scheduled_at < 12.hours.from_now && owner.scheduled_at > 4.hours.from_now
      #  CallRequestMailer.delay.remind(call_request)
      #elsif call_request.scheduled_at < 4.hours.from_now && owner.scheduled_at > 1.hour.from_now
      #  CallRequestMailer.delay.remind(call_request)
      #else
      #  CallRequestMailer.remind(owner)
      #end
    end
  end
end