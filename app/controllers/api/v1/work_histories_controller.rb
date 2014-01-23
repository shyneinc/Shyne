class Api::V1::WorkHistoriesController < Api::V1::BaseController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :find_mentor
  before_filter :find_work_history, except: [:index, :create]
  before_filter :check_type, except: [:index, :show]

  def index
    respond_with :api, @mentor.work_histories.load
  end

  def show
    respond_with :api, @work
  end

  def create
    @work = @mentor.work_histories.create(work_params)
    respond_with @work, location: api_mentor_work_histories_url(@mentor.id, @work)
  end

  def update
    respond_with :api, WorkHistory.update(@work.id, work_params)
  end

  def destroy
    respond_with :api, @work.destroy
  end

  private

  def work_params
    params.require(:work_history).permit(:company, :title, :date_started, :date_ended, :current_work, :mentor_id)
  end

  def find_mentor
    @mentor = Mentor.find(params[:mentor_id])
  end

  def find_work_history
    @work = @mentor.work_histories.find(params[:id])
  end

  def check_type
    if current_user.role_type != 'Mentor'
      render :json => {:error => 'User is not a mentor'}, :status => 401
    end
  end
end