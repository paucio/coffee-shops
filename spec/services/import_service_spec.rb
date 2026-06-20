# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportService do
  subject do
    described_class.new(
      importer: importer,
      model: model,
      unique_by: [:x, :y],
      update_only: [:name]
    )
  end

  let(:importer) { instance_double(Import::CsvImporter) }
  let(:model) { class_double(CoffeeShop) }
  let(:url) { 'http://example.com/data.csv' }
  let(:records) { attributes_for_list(:coffee_shop, 1) }

  before do
    allow(importer).to receive(:call).with(url).and_return(records)
    allow(model).to receive(:upsert_all)
  end

  describe '#call' do
    it 'calls the importer with the url' do
      subject.call(url)
      expect(importer).to have_received(:call).with(url)
    end

    it 'persists records with the injected config' do
      subject.call(url)
      expect(model).to have_received(:upsert_all).with(
        records,
        unique_by: [:x, :y],
        update_only: [:name],
        record_timestamps: true
      )
    end

    context 'with empty records' do
      let(:records) { [] }

      it 'does not call upsert_all' do
        subject.call(url)
        expect(model).not_to have_received(:upsert_all)
      end
    end

    context 'with exactly BATCH_SIZE records' do
      let(:records) { attributes_for_list(:coffee_shop, described_class::BATCH_SIZE) }

      it 'persists in a single batch' do
        subject.call(url)
        expect(model).to have_received(:upsert_all).once
      end
    end

    context 'with more than BATCH_SIZE records' do
      let(:records) { attributes_for_list(:coffee_shop, described_class::BATCH_SIZE + 1) }

      it 'persists in multiple batches' do
        subject.call(url)
        expect(model).to have_received(:upsert_all).twice
      end
    end
  end
end
