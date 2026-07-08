

class BarsController < ApplicationController
  include NearestParamsValidation

  before_action :validate_nearest_params!, only: :nearest

  def nearest
    shops = finder.call(**options)
    render json: BarSerializer.from_hashes(shops)
  end

  private

  def finder
    @finder ||= Finder::Nearest.new(
      grid: Finder::Grids::Bar,
      model: Bar
    )
  end

  def options
    options = { x: params[:x].to_f, y: params[:y].to_f }
    options[:limit] = params[:limit].to_i if params[:limit].present?
    options
  end
end
