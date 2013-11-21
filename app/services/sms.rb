module Sms
  extend ActiveSupport::Concern

  def send(message , to_number )
    client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
    
    if client
      res = client.account.sms.messages.create({
              :to => "#{to_number}",
              :from => "#{ENV['TWILIO_NUMBER']}",
              :body => "#{message}"
            })
      return res
    else
      return nil
    end
  end
  #should create canned messages here for approval .etc
end