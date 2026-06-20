# frozen_string_literal: true

module Importer
    module Downloaders
        class HttpDownloader
            def download(url)
                response = Faraday.get(url)

                validate_response!(response)

                response.body
            rescue Faraday::ConnectionFailed => e
                raise "Failed to connect to #{url}. Error: #{e.message}"
            end

            private

            def validate_response!(response)
                return if response.success?
                
                raise "Failed to download CSV data from #{url}. HTTP Status: #{response.status}"
            end
        end
    end
end