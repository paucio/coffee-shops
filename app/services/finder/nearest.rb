# frozen_string_literal: true

module Finder
  class Nearest
    def initialize(grid: Grids::CoffeeShop, model: CoffeeShop)
      @grid   = grid
      @model  = model
      @search = RadiusSearch.new(grid: grid)
    end

    def call(x:, y:, limit: 3)
      cell = grid.cell_for_coordinates(x, y)
      ids  = search.call(cell_x: cell[:x], cell_y: cell[:y], limit: limit)

      find_nearest(ids, x, y, limit)
    end

    private

    attr_reader :grid, :model, :search

    def find_nearest(ids, x, y, limit)
      model
        .where(id: ids)
        .map { |shop| { name: shop.name, x: shop.x, y: shop.y, distance: distance(shop, x, y) } }
        .sort_by { |h| h[:distance] }
        .first(limit)
    end

    def distance(shop, x, y)
      Math.sqrt(((shop.x - x) ** 2) + ((shop.y - y) ** 2)).round(4)
    end
  end
end
