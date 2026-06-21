# frozen_string_literal: true

module Finder
  class SpatialIndexer
    def initialize(grid:)
      @grid  = grid
    end

    def index(point)
      cell = grid.cell_for_coordinates(point.x, point.y)
      REDIS.sadd(grid.redis_key(cell[:x], cell[:y]), point.id)
    end

    def multi_index(points)
      points.each { |point| index(point) }
    end

    private

    attr_reader :grid
  end
end
