# frozen_string_literal: true

# This class is responsible for orchestrating the import process.
# It downloads a file from a given URL, parses it, and maps the parsed data to the desired format.
module Import
  class Pipeline
    def initialize(downloader:, parser:, mapper:)
      @downloader = downloader
      @parser = parser
      @mapper = mapper
    end

    def call(url)
      tempfile = downloader.download(url)
      parser.parse(tempfile, mapper.expected_columns).filter_map { |row| mapper.call(row) }
    ensure
      tempfile&.close!
    end

    private

    attr_reader :downloader, :parser, :mapper
  end
end
