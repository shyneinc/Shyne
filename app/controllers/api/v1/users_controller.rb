class Api::V1::UsersController < Api::V1::BaseController
  before_filter :authenticate_user!, :except => [:create]

  def show
    render :json => {:info => "Current User", :user => current_user, :confirmed => current_user.confirmed?}, :status => 200
  end

  def create
    @user = User.create(user_params)
    if @user.valid?
      sign_in(@user)
      respond_with @user, :location => api_users_path
    else
      respond_with @user.errors, :location => api_users_path
    end
  end

  def update
    respond_with :api, User.update(current_user.id, user_params)
  end

  def destroy
    respond_with :api, User.find(current_user.id).destroy
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :avatar, :password, :password_confirmation, :time_zone)
  end
end
