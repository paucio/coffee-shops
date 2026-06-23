# frozen_string_literal: true

# Base class for all parsers.
module Import
  module Parsers
    class BaseParser
      def parse(data)
        raise NotImplementedError, "Subclasses must implement the parse method"
      end
    end
  end
end
