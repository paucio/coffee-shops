# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Finder::SpatialIndexer do
  subject { described_class.new(grid: grid) }

  let(:grid)  { Finder::Grids::CoffeeShop }
  let(:point) { instance_double(CoffeeShop, id: 42, x: 75.0, y: 125.0) }

  before do
    allow(REDIS).to receive(:sadd)
  end

  describe '#index' do
    it 'stores the point id under the correct Redis key' do
      subject.index(point)

      expect(REDIS).to have_received(:sadd).with('coffee_shop_grid:x:1:y:2', 42)
    end

    it 'uses the grid to resolve the cell for the point coordinates' do
      expect(grid).to receive(:cell_for_coordinates).with(75.0, 125.0).and_call_original

      subject.index(point)
    end
  end

  describe '#multi_index' do
    let(:second_point) { instance_double(CoffeeShop, id: 99, x: 0.0, y: 0.0) }

    it 'indexes each point' do
      subject.multi_index([ point, second_point ])

      expect(REDIS).to have_received(:sadd).with('coffee_shop_grid:x:1:y:2', 42)
      expect(REDIS).to have_received(:sadd).with('coffee_shop_grid:x:0:y:0', 99)
    end
  end
end
