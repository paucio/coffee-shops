# frozen_string_literal: true

module Import
  module Mappers
    class BaseMapper
      def expected_columns
        self.class.expected_columns
      end

      def call(row)
        raise NotImplementedError, "#{self.class.name} must implement call(row)"
      end

      def self.expected_columns
        raise NotImplementedError, "#{name} must implement self.expected_columns"
      end
    end
  end
end
