require 'twilio-ruby'

module Sms

  extend ActiveSupport::Concern

  def send(message, to_number)
    client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
    
    if client
      res = client.account.messages.create(
              to: to_number,
              from: ENV['TWILIO_NUMBER'],
              body: message
            )
      puts res.status
    else
      puts "Something is wrong!"
    end
  end

  #should create canned messages here for approval .etc
end