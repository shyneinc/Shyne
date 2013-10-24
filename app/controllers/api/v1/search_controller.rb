class Api::V1::SearchController < Api::V1::BaseController
  def index
    if(params[:q].present?)
      respond_with :api, PgSearch.multisearch(params[:q])
    else
      render :json => {:error => 'No query parameter found'}, :status => 422
    end
  end
end
