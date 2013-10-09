class Api::V1::ExpertiesController < Api::V1::BaseController
  def show
    respond_with :api, Experty.find_by(mentor_id: params[:id])
  end

  def create
    respond_with :api, Experty.create(experty_params)
  end

  def destroy
    respond_with :api, Experty.destroy_all(mentor_id: params[:id])
  end

  private

  def experty_params
    params.require(:experty).permit(:industry_id, :mentor_id)
  end
end
