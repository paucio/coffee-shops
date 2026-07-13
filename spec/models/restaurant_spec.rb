# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  subject { build(:restaurant) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:x) }
    it { should validate_presence_of(:y) }

    it { should validate_uniqueness_of(:x).scoped_to(:y) }
  end
end
