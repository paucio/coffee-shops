# frozen_string_literal: true

module Import
  module Parsers
    class CsvParser < BaseParser
      EXPECTED_COLUMNS = 3

      def parse(csv_data)
        Enumerator.new do |yielder|
          CSV.new(csv_data, headers: false).each do |row|
            next unless row.size == EXPECTED_COLUMNS
            yielder << row
          end
        end
      end
    end
  end
end