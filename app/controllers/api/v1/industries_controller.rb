class Api::V1::IndustriesController < Api::V1::BaseController
  def index
    respond_with :api, Industry.select(:id, :title).map{ |i| [i.id, i.title.html_safe] }
  end
end
