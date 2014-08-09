class Api::V1::ReviewsController < Api::V1::BaseController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :find_advisor
  before_filter :find_review, except: [:index, :create]
  before_filter :check_type, except: [:index, :show]

  def index
    respond_with :api, @advisor.reviews.to_json({:include => [:member => {:include => :user}, :methods => [:get_avg_rating]], :methods => [:created_date]})
  end

  def show
    respond_with :api, @review
  end

  def create
    @review = @advisor.reviews.create(review_params) do |u|
      u.member = current_user.role
    end
    respond_with @review, location: api_advisor_reviews_url(@advisor.id, @review)
  end

  def update
    respond_with :api, Review.update(@review.id, review_params)
  end

  def destroy
    if @review.member_id == current_user.role.id
      respond_with :api, @review.destroy
    else
      render :json => {:error => 'Member is not authorized to delete this review'}, :status => 401
    end
  end

  private

  def review_params
    params.require(:review).permit(:review, :rating, :call_id)
  end

  def find_advisor
    @advisor = Advisor.find(params[:advisor_id])
  end

  def find_review
    @review = @advisor.reviews.find(params[:id])
  end

  def check_type
    if current_user.role_type != 'Member'
      render :json => {:error => 'Only members can write reviews'}, :status => 401
    end
  end
end