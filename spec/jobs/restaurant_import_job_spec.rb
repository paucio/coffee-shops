# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RestaurantImportJob do
  subject { described_class.perform_now(url) }

  let(:url)     { 'http://example.com/restaurants.csv' }
  let(:service) { instance_double(Import::BulkUpsert, call: nil) }

  before do
    allow(Import::BulkUpsert).to receive(:new).and_return(service)
  end

  describe '#perform' do
    it 'builds BulkUpsert with Restaurant as the model' do
      subject
      expect(Import::BulkUpsert).to have_received(:new).with(
        hash_including(model: Restaurant)
      )
    end

    it 'builds BulkUpsert with a Pipeline' do
      subject
      expect(Import::BulkUpsert).to have_received(:new).with(
        hash_including(importer: an_instance_of(Import::Pipeline))
      )
    end

    it 'passes the Restaurant unique constraint config' do
      subject
      expect(Import::BulkUpsert).to have_received(:new).with(
        hash_including(unique_by: [ :x, :y ], update_only: [ :name ])
      )
    end

    it 'passes a GridIndexer#multi_index method as after_persist' do
      subject
      expect(Import::BulkUpsert).to have_received(:new).with(
        hash_including(after_persist: an_instance_of(Method))
      )
    end

    it 'calls the service with the url' do
      subject
      expect(service).to have_received(:call).with(url)
    end
  end

  describe 'enqueueing' do
    subject { described_class.perform_later(url) }

    it 'enqueues on the restaurant_queue' do
      expect { subject }
        .to have_enqueued_job(described_class).on_queue('restaurant_queue').with(url)
    end
  end
end
