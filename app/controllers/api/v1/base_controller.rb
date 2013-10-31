class Api::V1::BaseController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/vnd.shyne.v1' }
  before_filter :set_timezone, :if => :current_user

  respond_to :json

  rescue_from Exception, with: :generic_exception
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def set_timezone
    Time.zone = current_user.time_zone
  end

  private

  def record_not_found(error)
    respond_to do |format|
      format.json  { render :json => {:error => error.message}, :status => 404 }
    end
  end

  def generic_exception(error)
    respond_to do |format|
      format.json  { render :json => {:error => error.message}, :status => 500 }
    end
  end
end
