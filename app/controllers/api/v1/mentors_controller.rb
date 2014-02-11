class Api::V1::MentorsController < Api::V1::BaseController
  before_filter :authenticate_user!, :except => [:index, :show, :show_fulldetails]

  def index
    mentors = []
    if (params[:featured].present? && params[:featured] == 'true')
      mentors_list = Mentor.approved.featured.not_deleted
    elsif (params[:skills].present?)
      mentors_list = Mentor.approved.not_deleted.skills(params[:skills])
    elsif (params[:industries].present?)
      mentors_list = Mentor.approved.industries(params[:industries])
    else
      mentors_list = Mentor.approved.not_deleted
    end
    mentors_list.each do |mentor|
      mentors << {
        id: mentor.id,
        user_id: mentor.user_id,
        role: mentor.current_position,
        full_name: mentor.full_name,
        company: mentor.current_company,
        city: mentor.city,
        state: mentor.state,
        rate_per_minute: mentor.rate_per_minute,
        photo_url: mentor.user.avatar.url,
        years_of_experience: mentor.years_of_experience,
        get_avg_rating: mentor.get_avg_rating,
        currently_working_at: mentor.currently_working_at,
        previously_worked_at: mentor.previously_worked_at
      }
    end

    respond_with :api, mentors
  end

  def show
    mentor = Mentor.find(params[:id])
    respond_with :api, mentor.to_json({:include => [:user],
                                       :methods => [:full_name, :avatar, :rate_per_minute, :get_avg_rating, :currently_working_at, :previously_worked_at]})
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
    params.require(:mentor).permit(:headline, :city, :state, :years_of_experience, :phone_number, :availability, :linkedin, :industries, :skills)
  end
end
