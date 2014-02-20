class Api::V1::CallRequestsController < Api::V1::BaseController
  before_filter :authenticate_user!
  before_filter :has_account?, only: [:create, :update]

  def index
    role = current_user.role_type.downcase
    respond_with :api, CallRequest.where("#{role}_id" => current_user.role_id).to_json({:include =>
                                                                                            {:mentor =>
                                                                                                 {:methods => [:full_name, :rate_per_minute, :phone_number]},
                                                                                             :member => {:methods => [:full_name, :phone_number]}
                                                                                            }})
  end

  def create
    call_request = CallRequest.create(call_request_params)
    if call_request
      CallRequestMailer.delay.request_proposed(call_request)
      Twilio::Sms.delay.send("Your have a new call request!", call_request.mentor.phone_number.to_s)
    end
    respond_with :api, call_request
  end

  def update
    respond_with :api, CallRequest.update(params[:id], call_request_params)
  end

  def show
    call_request = CallRequest.find(params[:id])
    respond_with :api, call_request.to_json(:include =>
                                                {:mentor =>
                                                     {:methods => [:full_name, :full_address, :photo_url, :rate_per_minute, :currently_working_at, :previously_worked_at]},
                                                 :member => {:include => :user, :methods => [:full_name, :photo_url]}
                                                })
  end

  def destroy
    @call_request = CallRequest.find(params[:id])
    if @call_request.member_id == current_user.role_id || @call_request.mentor_id == current_user.role_id
      respond_with :api, @call_request.destroy
    else
      render :json => {:error => 'Current user is not a participant of this call request'}, :status => 401
    end
  end

  private

  def call_request_params
    params.require(:call_request).permit(:agenda, :member_id, :mentor_id, :scheduled_at, :proposed_duration, :status)
  end

  def has_account?
    if current_user.role_type == 'Member' && !current_user.balanced_customer.cards.any?
      render :json => {:error => 'Member does not have a credit card on file'}, :status => 402
    elsif current_user.role_type == 'Mentor' && !current_user.balanced_customer.bank_accounts.any?
      render :json => {:error => 'Mentor does not have a bank account on file'}, :status => 402
    end
  end
end