# frozen_string_literal: true

module Importer
    module Parsers    
        class BaseParser
            def parse(data)
                raise NotImplementedError, "Subclasses must implement the parse method"
            end
        end
    end
end