class Api::V1::WorkHistoriesController < Api::V1::BaseController
	before_filter :authenticate_user!, except: [:index, :show]
	before_filter :check_mentor
	before_filter :check_work, except: [:index , :create]
	before_filter :check_type, except: [:index, :show]

	def index
		@allwork = @mentor.work_histories.all
		respond_with :api, @allwork
	end

	def show
		respond_with :api, @work
	end

	def create
		if @owner
			@work = current_user.role.work_histories.build(work_params)
			respond_with :api, @work
		else
			render json: { error: 'could not create your work history' }, status: 401
		end
	end

	def update
		if @owner #making sure if current_user is the owner
			respond_with :api, WorkHistory.update(@work.id, work_params)
		else
			render json: { error: 'could not update this work history'}, status: 401
		end
	end

	def destroy
		if @owner
			respond_with :api, @work.destroy
		else
			render json: { error: 'could not delete this work history'}, status: 401
		end
	end

	private

	def work_params
		params.require(:work).permit(:company, :title, :date_started, :date_ended, :current_work)
	end

	def check_type
		if current_user.role_type != 'Mentor'
			render json: { error: 'This function are for mentors only' }, status: 401
		else
			current_user.role == @mentor ? @owner = true : @owner = false
		end
	end

	def check_mentor
		@mentor = Mentor.find(params[:mentor_id])
	end

	def check_work
		@work = @mentor.work_histories.find(params[:id])
	end
end