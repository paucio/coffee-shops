# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Finder::SearchModel do
  describe '.call' do
    let!(:near_shop) { create(:coffee_shop, name: 'Near Shop', x: 1.0, y: 1.0) }
    let!(:far_shop)  { create(:coffee_shop, name: 'Far Shop', x: 10.0, y: 10.0) }
    let!(:other_shop) { create(:coffee_shop, name: 'Other Shop', x: 2.0, y: 2.0) }

    it 'returns only the records matching the given ids' do
      result = described_class.call(model: CoffeeShop, ids: [ near_shop.id, far_shop.id ], x: 0.0, y: 0.0)

      expect(result.map { |r| r[:id] }).to contain_exactly(near_shop.id, far_shop.id)
    end

    it 'includes id, name, x, y and distance for each record' do
      result = described_class.call(model: CoffeeShop, ids: [ near_shop.id ], x: 0.0, y: 0.0)

      expect(result.first).to eq(
        id: near_shop.id,
        name: 'Near Shop',
        x: 1.0,
        y: 1.0,
        distance: Math.sqrt(2).round(4)
      )
    end

    it 'rounds distance to 4 decimal places' do
      result = described_class.call(model: CoffeeShop, ids: [ far_shop.id ], x: 0.0, y: 0.0)

      expect(result.first[:distance]).to eq(Math.sqrt(200).round(4))
    end

    context 'when ids is empty' do
      it 'returns an empty array' do
        result = described_class.call(model: CoffeeShop, ids: [], x: 0.0, y: 0.0)

        expect(result).to be_empty
      end
    end

    context 'when no records match the given ids' do
      it 'returns an empty array' do
        result = described_class.call(model: CoffeeShop, ids: [ -1 ], x: 0.0, y: 0.0)

        expect(result).to be_empty
      end
    end
  end
end
