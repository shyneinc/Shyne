class Api::V1::IndustriesController < Api::V1::BaseController
  def index
    respond_with :api, Industry.select(:id, :title)
  end
end
