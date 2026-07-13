# frozen_string_literal: true

class RestaurantsController < ApplicationController
  include NearestParamsValidation

  before_action :validate_nearest_params!, only: :nearest

  def nearest
    restaurants = finder.call(**options)
    render json: RestaurantSerializer.from_hashes(restaurants)
  end

  private

  def finder
    @finder ||= Finder::Nearest.new(
      grid: Finder::Grids::Restaurant
    )
  end
end
