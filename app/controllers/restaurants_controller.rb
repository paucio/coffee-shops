# frozen_string_literal: true

class RestaurantsController < ApplicationController
  include NearestParamsValidation

  before_action :validate_nearest_params!, only: :nearest

  def nearest
    shops = finder.call(**options)
    render json: RestaurantSerializer.from_hashes(shops)
  end

  private

  def finder
    @finder ||= Finder::Nearest.new(
      grid: Finder::Grids::Restaurant
    )
  end
end
