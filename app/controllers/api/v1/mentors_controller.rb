class Api::V1::MentorsController < Api::V1::BaseController
  before_filter :authenticate_user!, :except => [:index, :show]

  def index
    mentors = []
    if (params[:featured].present? && params[:featured] == 'true')
      mentors_list = Mentor.approved.featured
    elsif (params[:experties].present?)
      mentors_list = Mentor.approved.experties(params[:experties])
    else
      mentors_list = Mentor.approved
    end
    mentors_list.each do |mentor|
      mentors << { id: mentor.id, role: mentor.headline, name: "#{mentor.user.first_name} #{mentor.user.last_name}", company: "Shyne", ratePerMinute: 5, photoUrl: mentor.user.avatar.url }
    end

    respond_with :api, mentors
  end

  def show
    respond_with :api, Mentor.find(params[:id])
  end

  def create
    if current_user.role_id == nil
      @mentor = Mentor.new(mentor_params)
      @mentor.user = current_user
      @mentor.user_id = current_user.id
      @mentor.save
      respond_with :api, @mentor
    else
      render :json => {:error => 'User already has a profile'}, :status => 401
    end
  end

  def update
    if current_user.role_type == 'Mentor'
      respond_with :api, Mentor.update(current_user.role_id, mentor_params)
    else
      render :json => {:error => 'User is not a mentor'}, :status => 401
    end
  end

  def destroy
    if current_user.role_type == 'Mentor'
      @mentor = Mentor.find(current_user.role_id)
      @mentor.user.role = nil
      @mentor.user.save
      respond_with :api, @mentor.destroy
    else
      render :json => {:error => 'User is not a mentor'}, :status => 401
    end
  end

  private

  def mentor_params
    params.require(:mentor).permit(:headline, :city, :state, :experties, :years_of_experience, :phone_number, :availability, :linkedin, :industries, :programs)
  end
end
