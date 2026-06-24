# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Import::Downloaders::BaseDownloader do
  subject { described_class.new }

  describe '#download' do
    it 'raises NotImplementedError' do
      expect { subject.download('http://example.com/file.csv') }
        .to raise_error(NotImplementedError)
    end

    it 'includes a message directing subclasses to implement the method' do
      expect { subject.download('http://example.com/file.csv') }
        .to raise_error(NotImplementedError, /Subclasses must implement the download method/)
    end
  end
end
