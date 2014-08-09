class Api::V1::WorkHistoriesController < Api::V1::BaseController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :find_advisor
  before_filter :find_work_history, except: [:index, :create]
  before_filter :check_type, except: [:index, :show]

  def index
    respond_with :api, @advisor.work_histories.to_json(:only => [:id, :advisor_id, :current_work, :title, :company, :date_started, :date_ended],
                                     :methods => [:started_month, :started_year, :ended_month, :ended_year])
  end

  def show
    respond_with :api, @work.to_json(:only => [:id, :advisor_id, :current_work, :title, :company, :date_started, :date_ended],
                                     :methods => [:started_month, :started_year, :ended_month, :ended_year])
  end

  def create
    @work = @advisor.work_histories.create(work_params)
    respond_with @work, location: api_advisor_work_histories_url(@advisor.id, @work)
  end

  def update
    respond_with :api, WorkHistory.update(@work.id, work_params)
  end

  def destroy
    respond_with :api, @work.destroy
  end

  private

  def work_params
    params.require(:work_history).permit(:company, :title, :date_started, :date_ended, :current_work, :advisor_id)
  end

  def find_advisor
    @advisor = Advisor.find(params[:advisor_id])
  end

  def find_work_history
    @work = @advisor.work_histories.find(params[:id])
  end

  def check_type
    if current_user.role_type != 'Advisor'
      render :json => {:error => 'User is not a advisor'}, :status => 401
    end
  end
end