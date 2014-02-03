class Api::V1::IndustriesController < Api::V1::BaseController
  def index
    industry_list = []
    industries = Industry.select(:id, :title).where("title LIKE ?", "%#{params[:query]}%")
    industries.each do |industry|
      industry_list << industry.title.html_safe
    end
    respond_with :api, industry_list.to_json
  end
end
