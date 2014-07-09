class Api::V1::UsersController < Api::V1::BaseController
  before_filter :authenticate_user!, :except => [:create, :show]

  def show
    if params[:user_id].present?
      user = User.find(params[:user_id])
    else
      user = current_user
    end
    if user
      render :json => {:info => "Current User", :user => user, :confirmed => user.confirmed?, :sign_in_count => user.sign_in_count}, :status => 200
    else
      render :json => {}, :status => 401
    end
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
    @user = User.update(current_user.id, user_params)
    if @user.valid?
      respond_with :api, @user
    else
      render :json => {:errors => @user.errors}, :status => 401
    end
  end

  def destroy
    respond_with :api, User.find(current_user.id).destroy
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :avatar, :password, :password_confirmation, :time_zone)
  end
end
