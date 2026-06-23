# frozen_string_literal: true

# Base class for all mappers.
# Mappers are responsible for transforming a row of data into a format suitable for the target model.
# They also define the expected columns in the input data.
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
