# frozen_string_literal: true

module Import
  module Mappers
    class CoffeeShopCsvMapper < BaseMapper
      def call(row)
        {
          name: row[0]&.strip,
          x: Float(row[1]),
          y: Float(row[2])
        }
      rescue ArgumentError, TypeError
        nil
      end
    end
  end
end
