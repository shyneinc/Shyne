class Api::V1::MembersController < Api::V1::BaseController
  before_filter :authenticate_user!, :except => [:index, :show]

  def index
    respond_with :api, Member.all
  end

  def show
    respond_with :api, Member.find(params[:id])
  end

  def create
    if current_user.role_id == nil
      @member = Member.new(member_params)
      @member.user = current_user
      @member.user_id = current_user.id
      if @member.save
        respond_with :api, @member
      else
        render :json => {:errors => @member.errors}, :status => 401
      end
    else
      render :json => {:error => 'User already has a profile'}, :status => 401
    end
  end

  def update
    if current_user.role_type == 'Member'
      respond_with :api, Member.update(current_user.role_id, member_params)
    else
      render :json => {:error => 'User is not a member'}, :status => 401
    end
  end

  def destroy
    if current_user.role_type == 'Member'
      @member = Member.find(current_user.role_id)
      @member.user.role = nil
      @member.user.save
      respond_with :api, @member.destroy
    else
      render :json => {:error => 'User is not a member'}, :status => 401
    end
  end

  private

  def member_params
    params.require(:member).permit(:phone_number, :industries, :city, :state)
  end
end
