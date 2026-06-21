# frozen_string_literal: true

module Import
  module Downloaders
    class HttpDownloader
      def download(url)
        tempfile = Tempfile.new([ "import", ".csv" ])

        response = connection.get(url) do |req|
          req.options.on_data = lambda do |chunk, _overall_received_bytes|
            tempfile.write(chunk)
          end
        end

        unless response.success?
          raise Import::Errors::DownloadError, "Failed to download from #{url}. HTTP Status: #{response.status}"
        end

        tempfile.rewind
        tempfile
      end

      private

      def connection
        @connection ||= Faraday.new
      end
    end
  end
end
