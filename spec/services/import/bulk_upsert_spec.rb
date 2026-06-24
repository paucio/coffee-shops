# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Import::BulkUpsert do
  subject do
    described_class.new(
      importer: importer,
      model: model,
      unique_by: [ :x, :y ],
      update_only: [ :name ],
      after_persist: after_persist
    )
  end

  let(:importer)      { instance_double(Import::Pipeline) }
  let(:model)         { class_double(CoffeeShop) }
  let(:after_persist) { instance_double(Proc, call: nil) }
  let(:url)           { 'http://example.com/coffee_shops.csv' }
  let(:records)       { attributes_for_list(:coffee_shop, 1) }
  let(:upsert_result) { instance_double(ActiveRecord::Result, rows: [ [ 1, 0.0, 0.0 ] ]) }

  before do
    allow(importer).to receive(:call).with(url).and_return(records)
    allow(model).to receive(:upsert_all).and_return(upsert_result)
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
        unique_by: [ :x, :y ],
        update_only: [ :name ],
        record_timestamps: true,
        returning: [ :id, :x, :y ]
      )
    end

    it 'calls after_persist with the upsert result' do
      subject.call(url)
      expect(after_persist).to have_received(:call).with(upsert_result.rows)
    end

    context 'without after_persist' do
      let(:after_persist) { nil }

      it 'raises NoMethodError' do
        expect { subject.call(url) }.to raise_error(NoMethodError)
      end
    end

    context 'with empty records' do
      let(:records) { [] }

      it 'does not call upsert_all' do
        subject.call(url)
        expect(model).not_to have_received(:upsert_all)
      end

      it 'does not call after_persist' do
        subject.call(url)
        expect(after_persist).not_to have_received(:call)
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
