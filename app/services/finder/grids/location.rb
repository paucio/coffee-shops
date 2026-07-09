# frozen_string_literal: true

module Finder
  module Grids
    class Location < Base
      def self.models
        [ ::Bar, ::CoffeeShop, ::Restaurant ]
      end
    end
  end
end
