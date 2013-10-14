class Api::V1::UsersController < Api::V1::BaseController
  def create
    respond_with :api, User.create(user_params)
  end

  def update
    if current_user.id == params[:id]
      respond_with :api, User.update(params[:id], user_params)
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
