class Api::V1::MentorsController < ApplicationController
  respond_to :json

  def index
    respond_with :api, Mentor.all
  end

  def show
    respond_with :api, Mentor.find(params[:id])
  end

  def create
    @mentor = Mentor.new(mentor_params)
    @mentor.user.save
    @mentor.user_id = @mentor.user.id
    @mentor.save
    respond_with :api, @mentor
  end

  def update
    respond_with :api, Mentor.update(params[:id], mentor_params)
  end

  def destroy
    respond_with :api, Mentor.destroy(params[:id])
  end

  private

  def mentor_params
    params.require(:mentor).permit(:first_name, :last_name, user_attributes: [:email, :password])
  end
end
