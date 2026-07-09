# frozen_string_literal: true

# This grid implementation is specific to coffee shops.
# It defines how to generate Redis keys for storing
# and retrieving coffee shop records based on their grid cell coordinates.
module Finder
  module Grids
    class CoffeeShop < Base
      def self.models
        [ ::CoffeeShop ]
      end

      private

      def self.default_type
        "coffee_shop"
      end
    end
  end
end
