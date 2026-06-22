# frozen_string_literal: true

class CoffeeShopsController < ApplicationController
  include NearestParamsValidation

  before_action :validate_nearest_params!, only: :nearest

  def nearest
    locations = finder.call(
      x: params[:x].to_f,
      y: params[:y].to_f,
      limit: params[:limit]&.to_i
    )
    render json: CoffeeShopSerializer.from_hashes(locations)
  end

  private

  def finder
    @finder ||= Finder::Nearest.new(
      grid: Grids::CoffeeShop,
      model: CoffeeShop
    )
  end
end
