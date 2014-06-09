class Api::V1::CallRequestsController < Api::V1::BaseController
  before_filter :authenticate_user!
  before_filter :has_account?, only: [:create, :update]

  def index
    role = current_user.role_type.downcase
    respond_with :api, CallRequest.where("#{role}_id" => current_user.role_id).to_json({:include =>
                                                                                            {:mentor =>
                                                                                                 {:methods => [:full_name, :rate_per_minute, :phone_number, :avg_call_duration, :get_avg_rating, :previous_companies, :current_position, :current_company, :total_reviews]},
                                                                                             :member => {:methods => [:full_name, :phone_number]}
                                                                                            }, :methods => [:scheduled_date, :credit_amount, :debit_amount]})
  end

  def create
    call_request = CallRequest.create(call_request_params)
    respond_with :api, call_request
  end

  def update
    respond_with :api, CallRequest.update(params[:id], call_request_params)
  end

  def show
    call_request = CallRequest.find(params[:id])
    respond_with :api, call_request.to_json(:include =>
                                                {:mentor =>
                                                     {:methods => [:full_name, :full_address, :photo_url, :rate_per_minute, :currently_working_at, :previously_worked_at, :avg_call_duration, :get_avg_rating, :previous_companies, :current_position, :current_company, :total_reviews]},
                                                 :member => {:include => :user, :methods => [:full_name, :photo_url]}
                                                }, :methods => [:scheduled_date, :twilio_number, :credit_amount, :debit_amount, :conversation_id])
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
    begin
      if current_user.role_type == 'Member' && !current_user.balanced_customer.cards.any?
        render :json => {:error => 'Your credit card information is not available'}, :status => 401
       #elsif current_user.role_type == 'Mentor' && !current_user.balanced_customer.bank_accounts.any?
       #  render :json => {:error => 'Mentor does not have a bank account on file'}, :status => 401
      end
    rescue Exception => e
      render :json => {:error => "Error:: something went wrong. Please try again later."}, :status => 401
    end
  end
end