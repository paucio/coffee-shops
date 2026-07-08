# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Finder::Grids::Bar do
  describe '.redis_key' do
    it 'returns the correct key format' do
      expect(described_class.redis_key(1, 2)).to eq('bar_grid:x:1:y:2')
    end

    it 'handles zero indices' do
      expect(described_class.redis_key(0, 0)).to eq('bar_grid:x:0:y:0')
    end

    it 'handles negative indices' do
      expect(described_class.redis_key(-1, -3)).to eq('bar_grid:x:-1:y:-3')
    end
  end

  describe '.cell_for_coordinates' do
    it 'inherits cell calculation from Base' do
      expect(described_class.cell_for_coordinates(75, 125)).to eq({ x: 1, y: 2 })
    end
  end
end