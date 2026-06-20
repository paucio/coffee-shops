# frozen_string_literal: true

module Importer
    class CsvImporter
        def initialize(downloader:, parser:)
            @downloader = downloader
            @parser = parser
        end
        
        def call(url)
            tempfile = downloader.download(url)
            parser.parse(tempfile).to_a
        ensure
            tempfile&.close!
        end

        private

        attr_reader :downloader, :parser
    end
end