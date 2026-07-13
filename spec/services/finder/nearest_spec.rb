# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Finder::Nearest do
  subject { described_class.new(grid: grid) }

  let(:grid)   { Finder::Grids::CoffeeShop }
  let(:search) { instance_double(Finder::RadiusSearch) }

  let(:shop_a) { { id: 1, name: 'Near Shop', x: 1.0, y: 1.0, distance: Math.sqrt(2).round(4) } }
  let(:shop_b) { { id: 2, name: 'Mid Shop', x: 5.0, y: 5.0, distance: Math.sqrt(50).round(4) } }
  let(:shop_c) { { id: 3, name: 'Far Shop', x: 10.0, y: 10.0, distance: Math.sqrt(200).round(4) } }

  before do
    allow(Finder::RadiusSearch).to receive(:new).and_return(search)
    allow(search).to receive(:call).and_return([ { type: 'coffee_shop', ids: [ 1, 2, 3 ] } ])
    allow(Finder::SearchModel).to receive(:call).and_return([ shop_a, shop_b, shop_c ])
  end

  describe '#call' do
    context 'when shops are found' do
      it 'queries the search with the correct cell coordinates' do
        subject.call(x: 75.0, y: 125.0)

        expect(search).to have_received(:call).with(cell_x: 1, cell_y: 2, limit: 3)
      end

      it 'returns results sorted by distance ascending' do
        result = subject.call(x: 0.0, y: 0.0)

        expect(result.map { |r| r[:name] }).to eq([ 'Near Shop', 'Mid Shop', 'Far Shop' ])
      end

      it 'includes name, x, y and distance in each result' do
        result = subject.call(x: 0.0, y: 0.0)

        expect(result.first).to include(:name, :x, :y, :distance)
      end

      it 'rounds distance to 4 decimal places' do
        result = subject.call(x: 0.0, y: 0.0)

        expect(result.first[:distance]).to eq(Math.sqrt(2).round(4))
      end

      it 'respects the limit' do
        allow(Finder::SearchModel).to receive(:call).and_return([ shop_a, shop_b, shop_c ])

        result = subject.call(x: 0.0, y: 0.0, limit: 2)

        expect(result.size).to eq(2)
      end
    end

    context 'when no shops are found' do
      before do
        allow(search).to receive(:call).and_return([])
        allow(Finder::SearchModel).to receive(:call).and_return([])
      end

      it 'returns an empty array' do
        expect(subject.call(x: 0.0, y: 0.0)).to be_empty
      end
    end
  end
end
