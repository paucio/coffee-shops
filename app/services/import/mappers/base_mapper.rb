# frozen_string_literal: true

module Import
  module Mappers
    class BaseMapper
      def call(row)
        raise NotImplementedError, "Subclasses must implement call(row)"
      end
    end
  end
end
