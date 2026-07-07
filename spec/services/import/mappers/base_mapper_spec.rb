# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Import::Mappers::BaseMapper do
  subject { described_class.new }

  describe '#call' do
    it 'raises NotImplementedError' do
      expect { subject.call([]) }.to raise_error(NotImplementedError, /call\(row\)/)
    end
  end
end
