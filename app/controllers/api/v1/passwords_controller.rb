class Api::V1::PasswordsController < Devise::PasswordsController
  protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/vnd.shyne.v1' }

  def create
    @user = User.send_reset_password_instructions(params[:user])
    if successfully_sent?(@user)
      render :json => nil, :status => 200
    else
      render :json => {:error => 'There was an error in sending password reset email'}, :status => 500
    end
  end

  def update
    @user = User.reset_password_by_token(params[:user])
    if @user.errors.empty?
      sign_in(@user)
      render :json => {:reset => true}, :status => 200
    else
      render :json => {:error => @user.errors.full_messages}, :status => 400
    end
  end
end