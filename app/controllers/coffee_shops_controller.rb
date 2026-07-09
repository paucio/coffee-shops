# frozen_string_literal: true

class CoffeeShopsController < ApplicationController
  include NearestParamsValidation

  before_action :validate_nearest_params!, only: :nearest

  def nearest
    shops = finder.call(**options)
    render json: CoffeeShopSerializer.from_hashes(shops)
  end

  private

  def finder
    @finder ||= Finder::Nearest.new(
      grid: Finder::Grids::CoffeeShop
    )
  end
end
