class Call < ActiveRecord::Base
  classy_enum_attr :status, default: :inprogress, enum: :call_status

  belongs_to :call_request
  has_many :reviews

  after_update :send_billing, :if => :status_changed?

  def send_billing
    if self.status.completed? && self.sid
     
      @client = Twilio::REST::Client.new "AC4f20ae17644502d367b100f451b5b8e0" , "ba9cd06f9049217ad193da230e2918af"
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
  handle_asynchronously :send_billing, :run_at => Proc.new { 1.minutes.from_now }

end
