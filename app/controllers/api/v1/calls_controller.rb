class Api::V1::CallsController < Api::V1::BaseController
  def index
    respond_with :api, Call.all
  end

  def show
    respond_with :api, Call.find(params[:id])
  end

  def create
    @call = Call.new(call_params)
    @call.save
    respond_with :api, @call
  end

  def update
    respond_with :api, Call.update(params[:id], call_params)
  end

  def destroy
    respond_with :api, Call.destroy(params[:id])
  end

  private

  def call_params
    params.require(:call).permit(:member_id, :mentor_id, :scheduled_at)
  end
end
