# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Import::Pipeline do
  subject do
    described_class.new(downloader: downloader, parser: parser, mapper: mapper)
  end

  let(:downloader) { instance_double(Import::Downloaders::HttpDownloader) }
  let(:parser) { instance_double(Import::Parsers::CsvParser) }
  let(:mapper) { instance_double(Import::Mappers::CoffeeShopMapper) }
  let(:tempfile) { instance_double(Tempfile) }
  let(:url) { 'http://example.com/coffee_shops.csv' }
  let(:expected_columns) { %i[name x y] }

  let(:raw_rows) do
    [
      [ 'Starbucks', '1.0', '2.0' ],
      [ 'malformatted', 'data', 'row' ],
      [ 'Blue Bottle', '3.0', '4.0' ]
    ]
  end

  before do
    allow(downloader).to receive(:download).with(url).and_return(tempfile)
    allow(mapper).to receive(:expected_columns).and_return(expected_columns)
    allow(parser).to receive(:parse).with(tempfile, expected_columns).and_return(raw_rows)
    allow(mapper).to receive(:call).with(raw_rows[0]).and_return({ name: 'Starbucks', x: 1.0, y: 2.0 })
    allow(mapper).to receive(:call).with(raw_rows[1]).and_return(nil)
    allow(mapper).to receive(:call).with(raw_rows[2]).and_return({ name: 'Blue Bottle', x: 3.0, y: 4.0 })
    allow(tempfile).to receive(:close!)
  end

  describe '#call' do
    it 'returns mapped records with nils filtered out' do
      expect(subject.call(url)).to eq([
        { name: 'Starbucks', x: 1.0, y: 2.0 },
        { name: 'Blue Bottle', x: 3.0, y: 4.0 }
      ])
    end

    it 'closes the tempfile after processing' do
      subject.call(url)
      expect(tempfile).to have_received(:close!)
    end

    context 'when parsing raises an error' do
      before { allow(parser).to receive(:parse).and_raise(RuntimeError, 'parse error') }

      it 'closes the tempfile even on error' do
        expect { subject.call(url) }.to raise_error(RuntimeError)
        expect(tempfile).to have_received(:close!)
      end
    end
  end
end
