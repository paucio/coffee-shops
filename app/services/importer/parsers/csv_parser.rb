# frozen_string_literal: true

module Importer
    module Parsers
        class CsvParser < BaseParser
            EXPECTED_COLUMNS = 3

            def parse(csv_data)
                CSV.parse(csv_data, headers: false).filter_map do |row|
                    build_record(row)
                end
            end

            private

            def build_record(row)
                return unless row.size == EXPECTED_COLUMNS

                {
                    name: row[0]&.strip,
                    x: row[1].to_f,
                    y: row[2].to_f
                }
            rescue ArgumentError, TypeError => e
                nil # Skip rows with invalid data
            end
        end
    end
end