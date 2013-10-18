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

  def confirm
    @user = User.confirm_by_token(params[:confirmation_token])
    if @user.errors.empty?
      sign_in(@user)
      render :json => { :confirmed => @user.confirmed? }, :status => 200
    else
      render :json => { :error => 'Confirmation token is invalid' }, :status => 400
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
