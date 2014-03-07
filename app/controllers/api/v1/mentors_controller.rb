class Api::V1::MentorsController < Api::V1::BaseController
  before_filter :authenticate_user!, :except => [:index, :show, :show_fulldetails]

  def index
    mentors = []
    if (params[:featured].present? && params[:featured] == 'true')
      mentors = Mentor.approved.featured.not_deleted
    elsif (params[:skills].present?)
      mentors = Mentor.approved.not_deleted.skills(params[:skills])
    elsif (params[:industries].present?)
      mentors = Mentor.approved.industries(params[:industries])
    else
      mentors = Mentor.approved.not_deleted
    end

    respond_with :api, mentors.to_json(:only => [:id, :user_id, :city, :state, :rate_per_minute, :years_of_experience],
                                       :methods => [:current_position, :current_company, :full_name, :photo_url, :rate_per_minute, :get_avg_rating, :currently_working_at, :previously_worked_at])
  end

  def show
    mentor = Mentor.find(params[:id])
    respond_with :api, mentor.to_json({:include => [:user],
                                       :methods => [:full_name, :avatar, :rate_per_minute, :get_avg_rating, :currently_working_at, :previously_worked_at, :avg_call_duration]})
  end

  def create
    if current_user.role_id == nil
      @mentor = Mentor.new(mentor_params)
      @mentor.user = current_user
      @mentor.user_id = current_user.id
      if @mentor.save
        respond_with :api, @mentor
      else
        render :json => {:errors => @mentor.errors}, :status => 401
      end
    else
      render :json => {:error => 'User already has a profile'}, :status => 401
    end
  end

  def update
    if current_user.role_type == 'Mentor'
      @mentor = Mentor.find(current_user.role_id)
      if @mentor.update(mentor_params)
        respond_with :api, @mentor
      else
        render :json => {:errors => @mentor.errors}, :status => 401
      end
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
    params.require(:mentor).permit(:headline, :city, :state, :years_of_experience, :phone_number, :availability, :linkedin, :industries, :skills, :schools)
  end
end
