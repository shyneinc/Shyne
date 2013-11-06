class CallHistory < ActiveRecord::Base
  classy_enum_attr :status, default: :inprogress

  belongs_to :call

  def send_billing
    if self.status.completed? && self.sid
     
      @client = Twilio::REST::Client.new ENV['twilio_sid'] , ENV['twilio_token']
      @log = @client.account.calls.get(self.sid.to_s)

      self.duration = @log.duration.to_i
      

      # if self.phone_number == self.call.member.phone_number
      #   #do billing here
      #   #send billing notification
      # else
      #   #money is on the way
      # end

      self.billed = true
      self.save
    end
  end
  handle_asynchronously :send_billing, :run_at => Proc.new { 3.minutes.from_now }
end
