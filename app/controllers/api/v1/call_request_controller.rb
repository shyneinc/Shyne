class Api::V1::CallRequestController < Api::V1::BaseController
  before_filter :authenticate_user!

  def show
    if current_user.role_type == 'Member'
      respond_with :api, CallRequest.find_by_member_id(current_user.role_id)
    elsif current_user.role_type == 'Mentor'
      respond_with :api, CallRequest.find_by_mentor_id(current_user.role_id)
    else
      render :json => {:error => 'User does not have a profile'}, :status => 401
    end
  end

  def create
    @CallRequest = CallRequest.new(call_params)
    @CallRequest.save
    respond_with :api, @CallRequest
  end

  def update
    respond_with :api, CallRequest.update(params[:id], call_params)
  end

  def destroy
    respond_with :api, CallRequest.destroy(params[:id])
  end

  private

  def call_params
    params.require(:call_request).permit(:member_id, :mentor_id, :scheduled_at)
  end
end