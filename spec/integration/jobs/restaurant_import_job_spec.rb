# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RestaurantImportJob, :integration do
  subject { described_class.perform_now(url) }

  let(:url) { 'http://example.com/restaurants.csv' }
  let(:connection) { instance_double(Faraday::Connection) }
  let(:response) { instance_double(Faraday::Response, success?: true, status: 200) }

  let(:csv_content) do
    <<~CSV
      Stake House,1.0,2.0
      Blue Bottle,3.5,4.5
      Peet's Restaurant,5.0,6.0
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

      it 'does not create any restaurants' do
        expect { subject }.not_to change(Restaurant, :count)
      end
    end

    context 'when the CSV has new records' do
      it 'creates restaurants from the CSV' do
        expect { subject }.to change(Restaurant, :count).by(3)
      end

      it 'persists the correct attributes' do
        subject

        expect(Restaurant.find_by(x: 1.0, y: 2.0).name).to eq('Stake House')
        expect(Restaurant.find_by(x: 3.5, y: 4.5).name).to eq('Blue Bottle')
        expect(Restaurant.find_by(x: 5.0, y: 6.0).name).to eq("Peet's Restaurant")
      end
    end

    context 'when the CSV contains existing records' do
      let!(:existing_restaurant) { create(:restaurant, name: 'Old Name', x: 1.0, y: 2.0) }

      it 'updates the name when a record with the same coordinates already exists' do
        expect { subject }.to change(Restaurant, :count).by(2)

        expect(existing_restaurant.reload.name).to eq('Stake House')
      end
    end

    context 'when the CSV contain malformed rows' do
      before do
        bad_csv = "Good Cafe,1.0,2.0\nBad Cafe,not_a_float,2.0\n"
        allow(connection).to receive(:get).with(url) do |&block|
          req = double('request', options: double('options').tap do |opts|
            allow(opts).to receive(:on_data=) { |proc| proc.call(bad_csv, bad_csv.bytesize, nil) }
          end)
          block.call(req)
          response
        end
      end

      it 'skips rows with invalid coordinates' do
        expect { subject }.to change(Restaurant, :count).by(1)
      end
    end
  end
end
