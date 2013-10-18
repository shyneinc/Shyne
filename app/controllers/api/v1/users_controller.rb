class Api::V1::UsersController < Api::V1::BaseController
  before_filter :authenticate_user!, :except => [:create]

  def show
    render :json => { :info => "Current User", :user => current_user, :confirmed => current_user.confirmed? }, :status => 200
  end

  def create
    @user = User.create(user_params)
    sign_in(@user)
    respond_with @user, :location => api_users_path
  end

  def update
    respond_with :api, User.update(current_user.id, user_params)
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
