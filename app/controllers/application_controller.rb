require "csv"

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def index
    @features_text = "feature 1,8,24\nfeature 2,32,96"
    @features_text = params.require(:features) if request.post?
    features = CSV.parse(@features_text).map { |(_, min, max)| min.to_f..max.to_f }
    @algorithm = Algorithm.new(features)
  end

end
