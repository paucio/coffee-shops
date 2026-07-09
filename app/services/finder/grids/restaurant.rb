# frozen_string_literal: true

module Finder
  module Grids
    class Restaurant < Base
      def self.models
        [ ::Restaurant ]
      end

      private

      def self.default_type
        'restaurant'
      end
    end
  end
end
