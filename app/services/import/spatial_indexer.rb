# frozen_string_literal: true

module Import
  class SpatialIndexer
    Point = Data.define(:id, :x, :y)

    def initialize(grid:)
      @grid = grid
    end

    def multi_index(points)
      points.map { |id, x, y| Point.new(id: id, x: x, y: y) }.each { |point| index(point) }
    end

    def index(point)
      cell = grid.cell_for_coordinates(point.x, point.y)
      REDIS.sadd(grid.redis_key(cell[:x], cell[:y]), point.id)
    end

    private

    attr_reader :grid
  end
end
