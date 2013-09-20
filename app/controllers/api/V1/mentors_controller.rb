class Api::V1::MentorsController < ApplicationController
  respond_to :json

  def index
    respond_with Mentor.all
  end
end
