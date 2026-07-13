# frozen_string_literal: true

class BarsController < ApplicationController
  include NearestParamsValidation

  before_action :validate_nearest_params!, only: :nearest

  def nearest
    bars = finder.call(**options)
    render json: BarSerializer.from_hashes(bars)
  end

  private

  def finder
    @finder ||= Finder::Nearest.new(
      grid: Finder::Grids::Bar
    )
  end
end
