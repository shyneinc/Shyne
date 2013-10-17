class Api::V1::UsersController < Api::V1::BaseController
  before_filter :authenticate_user!, :except => [:create]

  def create
    @user = User.create(user_params)
    sign_in(@user)
    respond_with @user, :location => api_show_current_user_path
  end

  def update
    respond_with :api, User.update(current_user.id, user_params)
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
