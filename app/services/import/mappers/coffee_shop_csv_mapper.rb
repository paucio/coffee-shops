# frozen_string_literal: true

# Mapper for converting CSV rows to CoffeeShop attributes.
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

      def self.expected_columns
        %i[name x y]
      end
    end
  end
end
