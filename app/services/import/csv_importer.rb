# frozen_string_literal: true

module Import
  class CsvImporter
    def initialize(downloader:, parser:, mapper:)
      @downloader = downloader
      @parser = parser
      @mapper = mapper
    end

    def call(url)
      tempfile = downloader.download(url)
      parser.parse(tempfile).filter_map { |row| mapper.call(row) }
    ensure
      tempfile&.close!
    end

    private

    attr_reader :downloader, :parser, :mapper
  end
end
