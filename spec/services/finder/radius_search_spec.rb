# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Finder::RadiusSearch do
  let(:grid) { Finder::Grids::CoffeeShop }

  subject { described_class.new(grid: grid) }

  before do
    allow(REDIS).to receive(:smembers).and_return([])
  end

  describe '#call' do
    context 'when results are found at radius 0' do
      before do
        allow(REDIS).to receive(:smembers)
          .with('coffee_shop_grid:x:1:y:2')
          .and_return([ 10, 11, 12 ])
      end

      it 'returns ids' do
        result = subject.call(cell_x: 1, cell_y: 2, limit: 3)

        expect(result).to contain_exactly({ ids: [ 10, 11, 12 ], type: "coffee_shop" })
      end

      it 'does not query beyond radius 0 since results are found' do
        subject.call(cell_x: 1, cell_y: 2, limit: 3)

        expect(REDIS).to have_received(:smembers).once
      end
    end

    context 'when results require radius expansion' do
      before do
        allow(REDIS).to receive(:smembers)
          .with('coffee_shop_grid:x:0:y:0')
          .and_return([ 10 ])

        allow(REDIS).to receive(:smembers)
          .with('coffee_shop_grid:x:1:y:0')
          .and_return([ 11, 12 ])
      end

      it 'expands the radius until the limit is reached' do
        result = subject.call(cell_x: 0, cell_y: 0, limit: 3)

        expect(result).to include({ ids: [ 10, 11, 12 ], type: "coffee_shop" })
      end
    end

    context 'when there are not enough results within MAX_RADIUS' do
      before do
        allow(REDIS).to receive(:smembers)
          .with('coffee_shop_grid:x:0:y:1')
          .and_return([ 10 ])
      end

      it 'stops at MAX_RADIUS and returns what was found' do
        result = subject.call(cell_x: 0, cell_y: 0, limit: 3)

        expect(result).to contain_exactly({ ids: [ 10 ], type: "coffee_shop" })
      end
    end

    context 'when no results exist anywhere' do
      it 'returns an empty array' do
        result = subject.call(cell_x: 0, cell_y: 0, limit: 3)

        expect(result).to be_empty
      end
    end

    context 'when multiple types of models are found' do
      let(:grid) { Finder::Grids::Location }

      before do
        allow(REDIS).to receive(:smembers)
          .with('coffee_shop_grid:x:0:y:0')
          .and_return([ 10 ])

        allow(REDIS).to receive(:smembers)
          .with('restaurant_grid:x:0:y:0')
          .and_return([ 20, 21 ])
      end

      it 'returns results grouped by type' do
        result = subject.call(cell_x: 0, cell_y: 0, limit: 3)

        expect(result).to contain_exactly(
          { ids: [ 10 ], type: "coffee_shop" },
          { ids: [ 20, 21 ], type: "restaurant" }
        )
      end
    end
  end
end
