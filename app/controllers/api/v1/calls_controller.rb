class Api::V1::CallsController < Api::V1::BaseController
  before_filter :authenticate_user!

  def show
    if current_user.role_type == 'Member'
      respond_with :api, Call.find_by_member_id(current_user.role_id)
    elsif current_user.role_type == 'Mentor'
      respond_with :api, Call.find_by_mentor_id(current_user.role_id)
    else
      render :json => {:error => 'User does not have a profile'}, :status => 401
    end
  end

  def create
    @call = Call.new(call_params)
    @call.save
    respond_with :api, @call
  end

  def update
    respond_with :api, Call.update(params[:id], call_params)
  end

  def destroy
    respond_with :api, Call.destroy(params[:id])
  end

  private

  def call_params
    params.require(:call).permit(:member_id, :mentor_id, :scheduled_at)
  end
end
