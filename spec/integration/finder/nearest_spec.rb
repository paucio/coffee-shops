# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Finder::Nearest, :integration do
  subject { described_class.new(grid: grid) }

  let(:grid) { Finder::Grids::CoffeeShop }
  let(:indexer) { Import::GridIndexer.new(grid: grid) }

  let!(:near_shop)   { create(:coffee_shop, name: 'Near Shop',   x: 1.0,  y: 1.0) }
  let!(:mid_shop)    { create(:coffee_shop, name: 'Mid Shop',    x: 5.0,  y: 5.0) }
  let!(:far_shop)    { create(:coffee_shop, name: 'Far Shop',    x: 50.0, y: 50.0) }

  before do
    indexer.multi_index([
      near_shop.attributes.values_at('id', 'x', 'y'),
      mid_shop.attributes.values_at('id', 'x', 'y'),
      far_shop.attributes.values_at('id', 'x', 'y')
    ])
  end

  describe '#call' do
    context 'when searching near the origin' do
      it 'returns shops sorted by distance ascending' do
        result = subject.call(x: 0.0, y: 0.0)

        expect(result.map { |r| r[:name] }).to eq([ 'Near Shop', 'Mid Shop', 'Far Shop' ])
      end

      it 'returns the correct attributes for each shop' do
        result = subject.call(x: 0.0, y: 0.0, limit: 1)

        expect(result.first).to include(
          id: near_shop.id,
          name: 'Near Shop',
          x: 1.0,
          y: 1.0,
          distance: Math.sqrt(2).round(4)
        )
      end

      it 'respects the limit' do
        result = subject.call(x: 0.0, y: 0.0, limit: 2)

        expect(result.size).to eq(2)
        expect(result.map { |r| r[:name] }).to eq([ 'Near Shop', 'Mid Shop' ])
      end
    end

    context 'when searching near a far shop' do
      it 'returns the far shop as the nearest' do
        result = subject.call(x: 50.0, y: 50.0, limit: 2)

        expect(result.map { |r| r[:name] }).to eq([ 'Far Shop', 'Mid Shop' ])
      end
    end

    context 'when no shops are indexed' do
      before { REDIS.flushdb }

      it 'returns an empty array' do
        expect(subject.call(x: 0.0, y: 0.0)).to be_empty
      end
    end
  end
end
