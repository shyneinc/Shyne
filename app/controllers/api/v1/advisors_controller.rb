class Api::V1::AdvisorsController < Api::V1::BaseController
  before_filter :authenticate_user!, :except => [:index, :show, :show_fulldetails]

  def index
    advisors = []
    if (params[:featured].present? && params[:featured] == 'true')
      advisors = Advisor.approved.featured.not_deleted
    elsif (params[:skills].present?)
      advisors = Advisor.approved.not_deleted.skills(params[:skills])
    elsif (params[:industries].present?)
      advisors = Advisor.approved.industries(params[:industries])
    else
      advisors = Advisor.approved.not_deleted
    end

    respond_with :api, advisors.to_json(:only => [:id, :user_id, :city, :state, :rate_per_minute, :years_of_experience],
                                       :methods => [:current_position, :current_company, :full_name, :photo_url, :rate_per_minute, :get_avg_rating, :currently_working_at, :previously_worked_at, :previous_companies, :total_reviews])
  end

  def show
    advisor = Advisor.find(params[:id])
    respond_with :api, advisor.to_json({:include => [:user],
                                       :methods => [:full_name, :avatar, :rate_per_minute, :get_avg_rating, :current_position, :current_company, :currently_working_at, :previously_worked_at, :avg_call_duration, :total_calls]})
  end

  def create
    if current_user.role_id == nil
      @advisor = Advisor.new(advisor_params)
      @advisor.user = current_user
      @advisor.user_id = current_user.id
      if @advisor.save
        respond_with :api, @advisor
      else
        render :json => {:errors => @advisor.errors}, :status => 401
      end
    else
      render :json => {:error => 'User already has a profile'}, :status => 401
    end
  end

  def update
    if current_user.role_type == 'Advisor'
      @advisor = Advisor.find(current_user.role_id)
      if @advisor.update(advisor_params)
        respond_with :api, @advisor
      else
        render :json => {:errors => @advisor.errors}, :status => 401
      end
    else
      render :json => {:error => 'User is not an advisor'}, :status => 401
    end
  end

  def destroy
    if current_user.role_type == 'Advisor'
      @advisor = Advisor.find(current_user.role_id)
      @advisor.user.role = nil
      @advisor.user.save
      respond_with :api, @advisor.destroy
    else
      render :json => {:error => 'User is not an advisor'}, :status => 401
    end
  end

  private

  def advisor_params
    params.require(:advisor).permit(:headline, :city, :state, :years_of_experience, :phone_number, :availability, :linkedin, :industries, :skills, :schools)
  end
end
