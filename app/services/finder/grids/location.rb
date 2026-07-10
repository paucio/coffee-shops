# frozen_string_literal: true

# This grid implementation is specific to locations.
# It defines how to generate Redis keys for storing
# and retrieving location records based on their grid cell coordinates.
module Finder
  module Grids
    class Location < Base
      def self.models
        [ ::Bar, ::CoffeeShop, ::Restaurant ]
      end
    end
  end
end
