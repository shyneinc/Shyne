module Twilio::Sms
  extend ActiveSupport::Concern

  @client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']

  def self.send_sms(message, to_number)
    if @client
      @client.account.sms.messages.create({
                                              :to => "#{to_number}",
                                              :from => "#{ENV['TWILIO_NUMBER']}",
                                              :body => "#{message}"
                                          })
    end
  end

  def self.send_approval(to_number)
    if @client
      self.send_sms("Your call request has been approved!", to_number)
    end
  end

  def self.send_request(to_number)
    if @client
      self.send_sms("You have a call request!", to_number)
    end
  end
end