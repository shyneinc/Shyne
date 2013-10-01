class Api::V1::MembersController < ApplicationController
  respond_to :json

  def index
    respond_with :api, Member.all
  end

  def show
    respond_with :api, Member.find(params[:id])
  end

  def create
    @member = Member.new(member_params)
    @member.user.save
    @member.user_id = @member.user.id
    @member.save
    respond_with :api, @member
  end

  def update
    respond_with :api, Member.update(params[:id], member_params)
  end

  def destroy
    respond_with :api, Member.destroy(params[:id])
  end

  private

  def member_params
    params.require(:member).permit(:first_name, :last_name, user_attributes: [:email, :password])
  end
end
