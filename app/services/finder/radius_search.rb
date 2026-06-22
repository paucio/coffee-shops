# frozen_string_literal: true

module Finder
  class RadiusSearch
    MAX_RADIUS = 10

    def initialize(grid:)
      @grid  = grid
    end

    def call(cell_x:, cell_y:, limit:)
      ids = []
      radius = 0

      while ids.size < limit && radius <= MAX_RADIUS
        border_cells(cell_x, cell_y, radius).each do |key|
          ids.concat(REDIS.smembers(key))
        end
        radius += 1
      end

      ids
    end

    private

    attr_reader :grid

    def border_cells(cell_x, cell_y, radius)
      (-radius..radius).flat_map do |dx|
        (-radius..radius).filter_map do |dy|
          # only border cells avoiding duplicates from inner cells
          next unless dx.abs == radius || dy.abs == radius

          grid.redis_key(cell_x + dx, cell_y + dy)
        end
      end
    end
  end
end
