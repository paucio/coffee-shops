# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Finder::Grids::Base do
  describe '.cell_for_coordinates' do
    it 'returns a hash with x and y cell indices' do
      expect(described_class.cell_for_coordinates(0, 0)).to eq({ x: 0, y: 0 })
    end

    it 'floors the division result' do
      expect(described_class.cell_for_coordinates(74, 74)).to eq({ x: 1, y: 1 })
    end

    it 'returns the correct cell at an exact boundary' do
      expect(described_class.cell_for_coordinates(50, 100)).to eq({ x: 1, y: 2 })
    end

    it 'handles negative coordinates' do
      expect(described_class.cell_for_coordinates(-1, -1)).to eq({ x: -1, y: -1 })
    end
  end

  describe '.redis_key' do
    it 'returns a string with the correct format' do
      expect(described_class.redis_key(1, 2, 'bar')).to eq('bar_grid:x:1:y:2')
    end
  end

  describe '.models' do
    it 'raises NotImplementedError' do
      expect { described_class.models }.to raise_error(NotImplementedError)
    end
  end
end
