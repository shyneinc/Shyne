namespace :calls  do
  desc "Tally payments at the end of the month"
  task :calc_duration => :environment do
    @client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
    CallRequest.where(status: :completed).find_each do |call_request|
      @conference = @client.account.conferences.get(call_request.conferencesid.to_s)
      @call_durations = Hash.new
      CallRequest.calls.find_each do |call|
        @call_durations[call.from_number] += @client.account.calls.get(call.sid.to_s).duration.to_i
      end
      @call_request.billable_duration = @durations.values.min_by(&:last)
      if @call_request.save
        CallMailer.delay.send_duration( @call_request )
      end
    end
  end

  desc "Process payments of all the completed calls"
  task :process_payment => :environment do
    #TODO
  end
end