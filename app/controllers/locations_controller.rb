#

class LocationsController < ApplicationController
  include NearestParamsValidator

  def nearest
    locations = finder.call(**options)
    render json: LocationSerializer.from_hashes(shops)
  end

  private

  def finder
    @finder ||= Finder::Nearest.new(
      grid: Finder::Grids::Location
    )
  end
end
