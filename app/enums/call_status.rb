class CallStatus < ClassyEnum::Base
  def fetch_duration
    false
  end
end

class CallStatus::Inprogress < CallStatus
end

class CallStatus::Completed < CallStatus
  def fetch_duration
    if owner.sid
      @client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
      @log = @client.account.calls.get(owner.sid.to_s)
      owner.duration = @log.duration.to_i
      owner.save
    end
  end
  handle_asynchronously :fetch_duration, :run_at => Proc.new { 3.minutes.from_now }
end

class CallStatus::Failed < CallStatus
end

class CallStatus::Canceled < CallStatus
end
