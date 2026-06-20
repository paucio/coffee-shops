# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CoffeeShopImportJob do
  let(:url) { 'http://example.com/coffee_shops.csv' }
  let(:service) { instance_double(ImportService, call: nil) }

  before do
    allow(ImportService).to receive(:new).and_return(service)
  end

  describe '#perform' do
    it 'builds ImportService with CoffeeShop as the model' do
      described_class.perform_now(url)
      expect(ImportService).to have_received(:new).with(
        hash_including(model: CoffeeShop)
      )
    end

    it 'builds ImportService with a CsvImporter' do
      described_class.perform_now(url)
      expect(ImportService).to have_received(:new).with(
        hash_including(importer: an_instance_of(Import::CsvImporter))
      )
    end

    it 'passes the CoffeeShop unique constraint config' do
      described_class.perform_now(url)
      expect(ImportService).to have_received(:new).with(
        hash_including(unique_by: [:x, :y], update_only: [:name])
      )
    end

    it 'calls the service with the url' do
      described_class.perform_now(url)
      expect(service).to have_received(:call).with(url)
    end
  end

  describe 'enqueueing' do
    it 'enqueues on the default queue' do
      expect { described_class.perform_later(url) }
        .to have_enqueued_job(described_class).on_queue('default').with(url)
    end
  end
end
