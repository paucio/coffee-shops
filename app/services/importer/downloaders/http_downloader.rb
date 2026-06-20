# frozen_string_literal: true

module Importer
    module Downloaders
        class HttpDownloader
            def download(url)
                tempfile = Tempfile.new(['import', '.csv'])

                response = connection.get(url) do |req|
                    req.options.on_data = lambda do |chunk, _overall_received_bytes|
                        tempfile.write(chunk)
                    end
                end

                raise "Failed to download from #{url}. HTTP Status: #{response.status}" unless response.success?

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