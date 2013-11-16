class CallStatus < ClassyEnum::Base
  def fetch_duration
    false
  end
end

class CallStatus::Inprogress < CallStatus
end

class CallStatus::Completed < CallStatus
  # TODO
  # Turn this into a rake task run it with whenever.
  # Seperate task to calculate duration and to do billing
  # Try alternate approach to calculate duration, where
  # its conference.start - conference.end
  def fetch_duration
    if owner.sid
      @client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
      @log = @client.account.calls.get(owner.sid.to_s)
      owner.duration = @log.duration.to_i

      if owner.save
        @conf = @client.account.conferences.get(owner.conferencesid.to_s)
        callers = Call.where(conferencesid: @conf.sid , status: :completed).count
        
        if @conf && @conf.status == 'completed' && callers > 1 
          @duration = @conf.date_updated.to_time - @conf.date_created.to_time
          
          @call_request = owner.call_request
          @call_request.billable_duration = @duration
          @call_request.conferencesid = @conf.sid

          if @call_request.save
            CallMailer.delay.send_duration( @call_request )
          end
        end
      end
      
    end
  end
  handle_asynchronously :fetch_duration, :run_at => Proc.new { 3.minutes.from_now }
end

class CallStatus::Failed < CallStatus
end

class CallStatus::Canceled < CallStatus
end
