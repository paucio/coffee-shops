# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BarSerializer do
  let(:input) do
    [
      { id: 1, name: 'Brewry', x: 1.0, y: 2.0, distance: 1.4142 },
      { id: 2, name: 'Blue Bottle', x: 3.0, y: 4.0, distance: 3.1623 }
    ]
  end

  subject { described_class.from_hashes(input) }

  it 'returns an array' do
    expect(subject[:data].size).to eq(2)
  end

  it 'sets the correct type' do
    expect(subject[:data]).to all(include(type: :bar))
  end

  it 'serializes all attributes' do
    expect(subject[:data].first[:attributes]).to eq(
      name: 'Brewry',
      x: 1.0,
      y: 2.0,
      distance: 1.4142
    )
  end

  it 'sets id as a string' do
    expect(subject[:data].first[:id]).to eq('1')
  end

  context 'with an empty collection' do
    let(:input) { [] }

    it 'returns an empty data array' do
      expect(subject[:data]).to eq([])
    end
  end
end
