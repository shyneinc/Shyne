class Api::V1::MembersController < ApplicationController
  respond_to :json

  def index
    respond_with :api, Member.all
  end

  def show
    respond_with :api, Member.find(params[:id])
  end

  def create
    respond_with :api, Member.create(member_params)
  end

  def update
    respond_with :api, Member.update(params[:id], member_params)
  end

  def destroy
    respond_with :api, Member.destroy(params[:id])
  end

  private

  def member_params
    params.require(:member).permit(:first_name, :last_name)
  end
end
