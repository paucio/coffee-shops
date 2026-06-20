# frozen_string_literal: true

module Importer
    module Parsers
        class CsvParser < BaseParser
            EXPECTED_COLUMNS = 3

            def parse(csv_data)
                Enumerator.new do |yielder|
                    CSV.new(csv_data, headers: false).each do |row|
                        next unless row.size == EXPECTED_COLUMNS

                        begin
                            yielder << {
                                name: row[0]&.strip,
                                x: Float(row[1]),
                                y: Float(row[2])
                            }
                        rescue ArgumentError, TypeError
                            next
                        end
                    end
                end
            end
        end
    end
end