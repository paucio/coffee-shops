# frozen_string_literal: true

module Import
  module Parsers
    class CsvParser < BaseParser
      def parse(csv_data, expected_columns)
        Enumerator.new do |yielder|
          CSV.new(csv_data, headers: false).each do |row|
            next unless row.size == expected_columns.size
            yielder << row
          end
        end
      end
    end
  end
end
