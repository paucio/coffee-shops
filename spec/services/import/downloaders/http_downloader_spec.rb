# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Import::Downloaders::HttpDownloader do
  subject { described_class.new }

  let(:connection) { instance_double(Faraday::Connection) }
  let(:url) { 'http://example.com/coffee_shops.csv' }
  let(:status) { 200 }
  let(:success) { true }
  let(:response) { instance_double(Faraday::Response, success?: success, status: status) }

  before do
    allow(Faraday).to receive(:new).and_return(connection)
    allow(connection).to receive(:get).and_return(response)
  end

  describe '#download' do
    context 'when the response is successful' do
      it 'returns a Tempfile' do
        expect(subject.download(url)).to be_a(Tempfile)
      end

      it 'returns a rewound file' do
        expect(subject.download(url).pos).to eq(0)
      end
    end

    context 'when the response is not successful' do
      let(:status) { 400 }
      let(:success) { false }

      it 'raises a DownloadError' do
        expect { subject.download(url) }
          .to raise_error(Import::Errors::DownloadError)
      end

      it 'includes the HTTP status in the error message' do
        expect { subject.download(url) }
          .to raise_error(Import::Errors::DownloadError, /HTTP Status: 400/)
      end

      it 'includes the url in the error message' do
        expect { subject.download(url) }
          .to raise_error(Import::Errors::DownloadError, /#{Regexp.escape(url)}/)
      end
    end
  end
end
