# frozen_string_literal: true

# This service is responsible for searching a model by its ids
# and calculating the distance from a given point (x, y).
module Finder
  class SearchModel
    def self.call(model:, ids:, x:, y:)
      new(model).call(ids: ids, x: x, y: y)
    end

    def call(ids:, x:, y:)
      model
        .where(id: ids)
        .map { |record| { id: record.id, name: record.name, x: record.x, y: record.y, distance: distance(record, x, y) } }
    end

    private

    attr_reader :model

    def initialize(model)
      @model = model
    end

    def distance(record, x, y)
      Math.sqrt((record.x - x)**2 + (record.y - y)**2).round(4)
    end
  end
end
