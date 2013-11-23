module Twilio::Sms
  extend ActiveSupport::Concern

  @client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']

  def self.send(message , to_number )
    if @client
      res = @client.account.sms.messages.create({
              :to => "#{to_number}",
              :from => "#{ENV['TWILIO_NUMBER']}",
              :body => "#{message}"
            })
      return true unless res == nil
    end
  end

  def  self.send_approval(to_number)
    if @client
      res = @client.account.sms.messages.create({
              :to => "#{to_number}",
              :from => "#{ENV['TWILIO_NUMBER']}",
              :body => "Your call request has been approved!"
            })
      return true unless res == nil
    end
  end

  def self.send_request(to_number)
    if @client
      res = @client.account.sms.messages.create({
              :to => "#{to_number}",
              :from => "#{ENV['TWILIO_NUMBER']}",
              :body => "Your have a call request!"
            })
      return true unless res == nil
    end
  end

  #should create canned messages here for approval .etc
end