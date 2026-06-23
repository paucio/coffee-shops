# frozen_string_literal: true

# Base class for all downloaders.
module Import
  module Downloaders
    class BaseDownloader
      def download(url)
        raise NotImplementedError, "Subclasses must implement the download method"
      end
    end
  end
end
