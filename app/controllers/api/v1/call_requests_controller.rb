class Api::V1::CallRequestsController < Api::V1::BaseController
  before_filter :authenticate_user!
  before_filter :has_account?, only: [:create, :update]

  def index
    role = current_user.role_type.downcase
    respond_with :api, CallRequest.find_by("#{role}_id" => current_user.role_id)
  end

  def create
    respond_with :api, CallRequest.create(call_request_params)
  end

  def update
    respond_with :api, CallRequest.update(params[:id], call_request_params)
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