# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Import::Parsers::CsvParser do
  subject { described_class.new }

  describe '#parse' do
    let(:csv_data) { StringIO.new(csv_content) }

    context 'with valid rows' do
      let(:csv_content) { "Starbucks,1.0,2.0\nBlue Bottle,3.0,4.0\n" }

      it 'returns an Enumerator' do
        expect(subject.parse(csv_data)).to be_an(Enumerator)
      end

      it 'yields raw field arrays for each row' do
        expect(subject.parse(csv_data).to_a).to eq([
          ['Starbucks', '1.0', '2.0'],
          ['Blue Bottle', '3.0', '4.0']
        ])
      end
    end

    context 'with rows that have wrong column count' do
      let(:csv_content) { "Starbucks,1.0\nBlue Bottle,3.0,4.0\nToo,Many,Columns,Here\n" }

      it 'skips rows that do not have exactly EXPECTED_COLUMNS columns' do
        expect(subject.parse(csv_data).to_a).to eq([
          ['Blue Bottle', '3.0', '4.0']
        ])
      end
    end

    context 'with an empty input' do
      let(:csv_content) { '' }

      it 'yields no rows' do
        expect(subject.parse(csv_data).to_a).to be_empty
      end
    end
  end
end
