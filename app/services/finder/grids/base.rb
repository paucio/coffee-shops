# frozen_string_literal: true

# Base class for all grid implementations.
module Finder
  module Grids
    class Base
      CELL_SIZE = 50

      def self.cell_for_coordinates(x, y)
        {
          x: (x / CELL_SIZE).floor,
          y: (y / CELL_SIZE).floor
        }
      end

      def self.redis_key(x, y)
        raise NotImplementedError, "Subclasses must implement redis_key"
      end
    end
  end
end
