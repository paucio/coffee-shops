# frozen_string_literal: true

module Finder
  class Nearest
    DEFAULT_LIMIT = ENV.fetch("NEAREST_DEFAULT_LIMIT", 3).to_i

    def initialize(grid:, model:)
      @grid   = grid
      @model  = model
      @search = RadiusSearch.new(grid: grid)
    end

    def call(x:, y:, limit: DEFAULT_LIMIT)
      cell = grid.cell_for_coordinates(x, y)
      ids  = search.call(cell_x: cell[:x], cell_y: cell[:y], limit: limit)

      find_nearest(ids, x, y, limit)
    end

    private

    attr_reader :grid, :model, :search

    def find_nearest(ids, x, y, limit)
      model
        .where(id: ids)
        .map { |record| { id: record.id, name: record.name, x: record.x, y: record.y, distance: distance(record, x, y) } }
        .sort_by { |h| h[:distance] }
        .first(limit)
    end

    def distance(record, x, y)
      Math.sqrt(((record.x - x) ** 2) + ((record.y - y) ** 2)).round(4)
    end
  end
end
