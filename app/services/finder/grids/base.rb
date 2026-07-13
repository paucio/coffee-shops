# frozen_string_literal: true

# Base class for all grid implementations.
module Finder
  module Grids
    class Base
      CELL_SIZE = 50

      def self.grid_types
        {
          "bar" => ::Bar,
          "coffee_shop" => ::CoffeeShop,
          "restaurant" => ::Restaurant
        }
      end

      def self.cell_for_coordinates(x, y)
        {
          x: (x / CELL_SIZE).floor,
          y: (y / CELL_SIZE).floor
        }
      end

      def self.redis_key(x, y, type = nil)
        type = default_type if type.nil?
        "#{type}_grid:x:#{x}:y:#{y}"
      end

      def self.models
        raise NotImplementedError, "Subclasses must implement the `models` method"
      end
    end
  end
end
