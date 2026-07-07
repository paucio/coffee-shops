# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /coffee_shops/nearest', type: :request do
  let(:finder) { instance_double(Finder::Nearest) }

  before do
    allow(Finder::Nearest).to receive(:new).and_return(finder)
    allow(finder).to receive(:call).and_return([
      { id: 1, name: 'Near Shop', x: 1.0, y: 1.0, distance: 1.4142 }
    ])
  end

  context 'with valid params' do
    let(:params) { { x: '1.0', y: '2.0' } }

    before { get '/coffee_shops/nearest', params: params }

    it 'returns 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns a JSON:API compliant response' do
      expect(response.parsed_body).to include('data')
      expect(response.parsed_body['data']).to be_an(Array)
    end

    it 'passes x and y to the finder' do
      expect(finder).to have_received(:call).with(x: 1.0, y: 2.0)
    end
  end

  context 'with limit param' do
    let(:params) { { x: '1.0', y: '2.0', limit: '2' } }

    before { get '/coffee_shops/nearest', params: params }

    it 'passes limit to the finder' do
      expect(finder).to have_received(:call).with(x: 1.0, y: 2.0, limit: 2)
    end
  end

  context 'with missing required params' do
    it 'returns 400 when x is missing' do
      get '/coffee_shops/nearest', params: { y: '2.0' }
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns 400 when y is missing' do
      get '/coffee_shops/nearest', params: { x: '1.0' }
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns 400 when both are missing' do
      get '/coffee_shops/nearest'
      expect(response).to have_http_status(:bad_request)
    end
  end

  context 'when a database error occurs' do
    before do
      allow(finder).to receive(:call).and_raise(ActiveRecord::StatementInvalid)
      get '/coffee_shops/nearest', params: { x: '1.0', y: '2.0' }
    end

    it 'returns 503' do
      expect(response).to have_http_status(:service_unavailable)
    end

    it 'returns a JSON error body' do
      expect(response.parsed_body).to include('error')
    end
  end

  context 'with invalid param types' do
    it 'returns 400 when x is not a number' do
      get '/coffee_shops/nearest', params: { x: 'abc', y: '2.0' }
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns 400 when y is not a number' do
      get '/coffee_shops/nearest', params: { x: '1.0', y: 'abc' }
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns 400 when limit is not an integer' do
      get '/coffee_shops/nearest', params: { x: '1.0', y: '2.0', limit: 'abc' }
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns 400 when limit is zero' do
      get '/coffee_shops/nearest', params: { x: '1.0', y: '2.0', limit: '0' }
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns 400 when limit is negative' do
      get '/coffee_shops/nearest', params: { x: '1.0', y: '2.0', limit: '-1' }
      expect(response).to have_http_status(:bad_request)
    end
  end
end
