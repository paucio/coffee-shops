# frozen_string_literal: true

# This service finds the nearest records to a given point (x, y) within a grid.
# It uses a RadiusSearch to find candidate records
# and then calculates the actual distances to return the closest ones.
module Finder
  class Nearest
    DEFAULT_LIMIT = ENV.fetch("NEAREST_DEFAULT_LIMIT", 3).to_i

    def initialize(grid:)
      @grid   = grid
      @search = RadiusSearch.new(grid: grid)
    end

    def call(x:, y:, limit: DEFAULT_LIMIT)
      cell = grid.cell_for_coordinates(x, y)
      ids_per_type  = search.call(cell_x: cell[:x], cell_y: cell[:y], limit: limit)

      find_nearest(ids_per_type, x, y, limit)
    end

    private

    attr_reader :grid, :search

    def find_nearest(ids_per_type, x, y, limit)
      nearest_records = []

      ids_per_type.each do |location|
        model = grid.grid_types[location[:type]]

        next unless model

        nearest_records.concat(
          Finder::SearchModel.call(model: model, ids: location[:ids], x: x, y: y)
        )
      end

      nearest_records
        .sort_by { |h| h[:distance] }
        .first(limit)
    end
  end
end
