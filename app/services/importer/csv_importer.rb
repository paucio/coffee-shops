# frozen_string_literal: true

module Importer
    class CsvImporter
        def initialize(downloader:, parser:)
            @downloader = downloader
            @parser = parser
        end
        
        def call(url)
            csv_data = downloader.download(url)
            parser.parse(csv_data)
        end

        private

        attr_reader :downloader, :parser
    end
end