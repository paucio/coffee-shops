# frozen_string_literal: true

# Service for indexing records spatially using a grid system.
# It takes a grid object that defines how to map coordinates to grid cells,
# and provides methods to index multiple points or a single point
# into Redis for efficient spatial querying.
module Import
  class SpatialIndexer
    Point = Data.define(:id, :x, :y)

    def initialize(grid:)
      @grid = grid
    end

    def multi_index(points)
      grouped = points
        .map { |id, x, y| Point.new(id: id, x: x, y: y) }
        .group_by { |point| grid.cell_for_coordinates(point.x, point.y) }

      REDIS.pipelined do |pipe|
        grouped.each do |cell, cell_points|
          pipe.sadd(grid.redis_key(cell[:x], cell[:y]), cell_points.map(&:id))
        end
      end
    end

    def index(point)
      cell = grid.cell_for_coordinates(point.x, point.y)
      REDIS.sadd(grid.redis_key(cell[:x], cell[:y]), point.id)
    end

    private

    attr_reader :grid
  end
end
