# frozen_string_literal: true

# This grid implementation is specific to coffee shops. 
# It defines how to generate Redis keys for storing 
# and retrieving coffee shop records based on their grid cell coordinates.
module Finder
  module Grids
    class CoffeeShop < Base
      def self.redis_key(x, y)
        "coffee_shop_grid:x:#{x}:y:#{y}"
      end
    end
  end
end
