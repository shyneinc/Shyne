class Api::V1::SearchController < Api::V1::BaseController
  def index
    if(params[:q].present?)
      results = PgSearch.multisearch(params[:q])
      mentor_ids = []
      results.each { |result| mentor_ids << result[:searchable_id] }
      if(mentor_ids.count > 0)
        respond_with :api, Mentor.find(mentor_ids.split(',')).to_json(:only => [:id, :headline, :years_of_experience], :methods => [:full_name, :avatar])
      elsif
        render :json => {:info => 'No results found'}, :status => 200
      end
    else
      render :json => {:error => 'No query parameter found'}, :status => 422
    end
  end
end
