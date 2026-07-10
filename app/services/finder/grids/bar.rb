# frozen_string_literal: true

# This grid implementation is specific to bars.
# It defines how to generate Redis keys for storing
# and retrieving bar records based on their grid cell coordinates.
module Finder
  module Grids
    class Bar < Base
      def self.models
        [ ::Bar ]
      end

      private

      def self.default_type
        "bar"
      end
    end
  end
end
