# frozen_string_literal: true

# This grid implementation is specific to restaurants.
# It defines how to generate Redis keys for storing
# and retrieving restaurant records based on their grid cell coordinates.
module Finder
  module Grids
    class Restaurant < Base
      def self.models
        [ ::Restaurant ]
      end

      private

      def self.default_type
        "restaurant"
      end
    end
  end
end
