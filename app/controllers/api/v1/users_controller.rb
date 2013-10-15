class Api::V1::UsersController < Api::V1::BaseController
  def create
    respond_with User.create(user_params), :location => api_show_current_user_path
  end

  def update
    if current_user
      respond_with :api, User.update(current_user.id, user_params)
    else
      render :json => {:error => 'User is not logged in'}, :status => 401
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
