class Api::V1::IndustriesController < Api::V1::BaseController
  def index
    # TODO: Need to clean this up, do something like:
    # respond_with :api, Industry.select(:id, :title).map{ |i| [i.id, i.title.html_safe] }
    industry_list = []
    industries = Industry.select(:id, :title).where("title LIKE ?", "%#{params[:query]}%")
    industries.each do |industry|
      industry_list << industry.title.html_safe
    end
    respond_with :api, industry_list.to_json
  end
end
