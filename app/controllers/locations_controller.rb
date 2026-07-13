# frozen_string_literal: true

class LocationsController < ApplicationController
  include NearestParamsValidation

  before_action :validate_nearest_params!, only: :nearest

  def nearest
    locations = finder.call(**options)
    render json: LocationSerializer.from_hashes(locations)
  end

  private

  def finder
    @finder ||= Finder::Nearest.new(
      grid: Finder::Grids::Location
    )
  end
end
