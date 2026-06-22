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
      grid: Finder::Grids::CoffeeShop,
      model: CoffeeShop
    )
  end

  def options
    options = { x: params[:x].to_f, y: params[:y].to_f }
    options[:limit] = params[:limit].to_i if params[:limit].present?
    options
  end
end
