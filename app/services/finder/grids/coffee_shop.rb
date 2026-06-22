# frozen_string_literal: true

module Finder
  module Grids
    class CoffeeShop < Base
      def self.redis_key(x, y)
        "coffee_shop_grid:x:#{x}:y:#{y}"
      end
    end
  end
end
