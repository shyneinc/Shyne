class Api::V1::SearchController < Api::V1::BaseController
  def index
    if (params[:q].present?)
      pg = params[:pg] || 1
      results = PgSearch.multisearch(params[:q]).page(pg)
      advisor_ids = []
      results.each { |result| advisor_ids << result[:searchable_id] }
      if (advisor_ids.count > 0)
        advisors = Advisor.find(advisor_ids.split(','))
        respond_with :api, advisors.to_json(:only => [:id, :user_id, :city, :state, :headline, :years_of_experience, :full_address, :rate_per_minute, :city, :state],
                                            :methods => [:current_position, :current_company, :full_name, :photo_url, :rate_per_minute, :get_avg_rating, :currently_working_at, :previously_worked_at, :previous_companies, :total_reviews, :slug])
      elsif render :json => {:info => 'No results found'}, :status => 200
      end
    else
      render :json => {:error => 'No query parameter found'}, :status => 422
    end
  end
end
