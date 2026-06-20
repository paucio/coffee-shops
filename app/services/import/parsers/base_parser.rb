# frozen_string_literal: true

module Import
  module Parsers    
    class BaseParser
      def parse(data)
        raise NotImplementedError, "Subclasses must implement the parse method"
      end
    end
  end
end