# frozen_string_literal: true

module Import
  module Mappers
    class BarMapper < BaseMapper
      def call(row)
        raise ArgumentError, "blank name" if row[0].blank?

        {
          name: row[0].strip,
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
