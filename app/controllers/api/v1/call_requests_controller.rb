class Api::V1::CallRequestsController < Api::V1::BaseController
  before_filter :authenticate_user!

  def index
    if current_user.role_type == 'Member'
      respond_with :api, CallRequest.find_by_member_id(current_user.role_id)
    elsif current_user.role_type == 'Mentor'
      respond_with :api, CallRequest.find_by_mentor_id(current_user.role_id)
    else
      render :json => {:error => 'User does not have a profile'}, :status => 401
    end
  end

  def create
    #TODO: Make sure member has a CC on record
    respond_with :api, CallRequest.create(call_request_params)
  end

  def update
    #TODO: Before approving, make sure mentor has a bank acct on record
    respond_with :api, CallRequest.update(params[:id], call_request_params)
  end

  def destroy
    @call_request = CallRequest.find(params[:id])
    if @call_request.member_id == current_user.role_id || @call_request.mentor_id == current_user.role_id
      respond_with :api, @call_request.destroy
    else
      render :json => {:error => 'Current user is not the creator of this call request'}, :status => 401
    end
  end

  private

  def call_request_params
    params.require(:call_request).permit(:member_id, :mentor_id, :scheduled_at, :status)
  end
end