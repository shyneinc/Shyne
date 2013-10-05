class Api::V1::MentorsController < Api::V1::BaseController
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
    @mentor.mentor_status_id = MentorStatus.by_status('Applied').id
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
    params.require(:mentor).permit(:first_name, :last_name, :headline, :years_of_experience, :phone_number,
                                   :availability, user_attributes: [:email, :password, :password_confirmation])
  end
end
