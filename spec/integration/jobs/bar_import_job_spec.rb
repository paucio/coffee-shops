# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BarImportJob, :integration do
  subject { described_class.perform_now(url) }

  let(:url) { 'http://example.com/bars.csv' }
  let(:connection) { instance_double(Faraday::Connection) }
  let(:response) { instance_double(Faraday::Response, success?: true, status: 200) }

  let(:csv_content) do
    <<~CSV
      Brewry,1.0,2.0
      Blue Bottle,3.5,4.5
      Peet's Coffee,5.0,6.0
    CSV
  end

  before do
    allow(Faraday).to receive(:new).and_return(connection)
    allow(connection).to receive(:get).with(url) do |&block|
      req = double('request', options: double('options').tap do |opts|
        allow(opts).to receive(:on_data=) { |proc| proc.call(csv_content, csv_content.bytesize, nil) }
      end)
      block.call(req)
      response
    end
  end

  describe '#perform' do
    context 'when the CSV is empty' do
      let(:csv_content) { '' }

      it 'does not create any bars' do
        expect { subject }.not_to change(Bar, :count)
      end
    end

    context 'when the CSV has new records' do
      it 'creates bars from the CSV' do
        expect { subject }.to change(Bar, :count).by(3)
      end

      it 'persists the correct attributes' do
        subject

        expect(Bar.find_by(x: 1.0, y: 2.0).name).to eq('Starbucks')
        expect(Bar.find_by(x: 3.5, y: 4.5).name).to eq('Blue Bottle')
        expect(Bar.find_by(x: 5.0, y: 6.0).name).to eq("Peet's Coffee")
      end
    end

    context 'when the CSV contains existing records' do
      let!(:existing_bar) { create(:bar, name: 'Old Name', x: 1.0, y: 2.0) }

      it 'updates the name when a record with the same coordinates already exists' do
        expect { subject }.to change(Bar, :count).by(2)

        expect(existing_bar.reload.name).to eq('Starbucks')
      end
    end

    context 'when the CSV contain malformed rows' do
      before do
        bad_csv = "Good Bar,1.0,2.0\nBad Bar,not_a_float,2.0\n"
        allow(connection).to receive(:get).with(url) do |&block|
          req = double('request', options: double('options').tap do |opts|
            allow(opts).to receive(:on_data=) { |proc| proc.call(bad_csv, bad_csv.bytesize, nil) }
          end)
          block.call(req)
          response
        end
      end

      it 'skips rows with invalid coordinates' do
        expect { subject }.to change(CoffeeShop, :count).by(1)
      end
    end
  end
end
