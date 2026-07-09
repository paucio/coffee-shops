# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /restaurants/nearest', :integration, type: :request do
  let(:indexer) { Import::GridIndexer.new(grid: Finder::Grids::Restaurant) }

  let!(:near_shop) { create(:restaurant, name: 'Near Restaurant', x: 1.0,  y: 1.0) }
  let!(:mid_shop)  { create(:restaurant, name: 'Mid Restaurant',  x: 5.0,  y: 5.0) }
  let!(:far_shop)  { create(:restaurant, name: 'Far Restaurant',  x: 50.0, y: 50.0) }

  before do
    indexer.multi_index([
      near_shop.attributes.values_at('id', 'x', 'y'),
      mid_shop.attributes.values_at('id', 'x', 'y'),
      far_shop.attributes.values_at('id', 'x', 'y')
    ])
  end

  it 'returns 200' do
    get '/restaurants/nearest', params: { x: '0.0', y: '0.0' }
    expect(response).to have_http_status(:ok)
  end

  it 'returns a JSON:API compliant structure' do
    get '/restaurants/nearest', params: { x: '0.0', y: '0.0' }
    expect(response.parsed_body).to include('data')
    expect(response.parsed_body['data']).to be_an(Array)
  end

  it 'returns shops sorted by distance ascending' do
    get '/restaurants/nearest', params: { x: '0.0', y: '0.0' }

    names = response.parsed_body['data'].map { |r| r['attributes']['name'] }
    expect(names).to eq([ 'Near Restaurant', 'Mid Restaurant', 'Far Restaurant' ])
  end

  it 'returns the correct attributes for each shop' do
    get '/restaurants/nearest', params: { x: '0.0', y: '0.0', limit: '1' }

    attributes = response.parsed_body['data'].first['attributes']
    expect(attributes).to include(
      'name' => 'Near Restaurant',
      'x' => 1.0,
      'y' => 1.0,
      'distance' => Math.sqrt(2).round(4)
    )
  end

  it 'respects the limit param' do
    get '/restaurants/nearest', params: { x: '0.0', y: '0.0', limit: '2' }

    expect(response.parsed_body['data'].size).to eq(2)
  end

  it 'returns an empty data array when no restaurants are indexed' do
    REDIS.flushdb
    get '/restaurants/nearest', params: { x: '0.0', y: '0.0' }

    expect(response.parsed_body['data']).to eq([])
  end
end
