# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Import::Parsers::BaseParser do
  subject { described_class.new }

  describe '#parse' do
    it 'raises NotImplementedError' do
      expect { subject.parse(nil) }.to raise_error(NotImplementedError, /parse method/)
    end
  end
end
