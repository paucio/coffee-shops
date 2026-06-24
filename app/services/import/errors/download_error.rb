# frozen_string_literal: true

# This class defines a custom error for handling download failures during the import process.
module Import
  module Errors
    class DownloadError < StandardError; end
  end
end
