# frozen_string_literal: true

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
