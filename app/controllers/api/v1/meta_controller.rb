class Api::V1::MetaController < Api::V1::BaseController
  def index
      render :json => {:twilio_number => ENV['TWILIO_NUMBER'], :environment => Rails.env}, :status => 200
  end
end
