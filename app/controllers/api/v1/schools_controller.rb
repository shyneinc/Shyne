class Api::V1::SchoolsController < Api::V1::BaseController
  def index
    respond_with :api, School.select(:id, :name).map{ |i| [i.id, i.name.html_safe] }
  end
end
