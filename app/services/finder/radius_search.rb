# frozen_string_literal: true

# This service finds the nearest records to a given point (x, y) within a grid.
module Finder
  class RadiusSearch
    MAX_RADIUS = 20

    def initialize(grid:)
      @grid  = grid
    end

    def call(cell_x:, cell_y:, limit:)
      ids = []
      radius = 0

      while ids.size < limit && radius <= MAX_RADIUS
        border_cells(cell_x, cell_y, radius).each do |cells|
          ids.concat(cells)
        end
        radius += 1
      end

      ids.group_by { |h| h[:type] }
         .map { |type, entries| { type: type, ids: entries.flat_map { |e| e[:ids] } } }
    end

    private

    attr_reader :grid

    def border_cells(cell_x, cell_y, radius)
      (-radius..radius).flat_map do |dx|
        (-radius..radius).filter_map do |dy|
          # only border cells avoiding duplicates from inner cells
          next unless dx.abs == radius || dy.abs == radius

          grid.models.flat_map do |model|
            model_name = model.name.underscore
            key = grid.redis_key(cell_x + dx, cell_y + dy, model_name)

            REDIS.smembers(key).map do |id|
              { type: model_name, ids: [ id ] }
            end
          end
        end
      end
    end
  end
end
