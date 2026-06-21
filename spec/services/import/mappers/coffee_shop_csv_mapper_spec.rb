# frozen_string_literal: true

require "rails_helper"

RSpec.describe Import::Mappers::CoffeeShopCsvMapper do
  subject { described_class.new }

  describe "#call" do
    context "with a valid row" do
      it "maps columns to model attributes" do
        expect(subject.call([ "Starbucks", "1.5", "2.5" ])).to eq(
          name: "Starbucks",
          x: 1.5,
          y: 2.5
        )
      end

      it "strips whitespace from name" do
        expect(subject.call([ "  Blue Bottle  ", "1.0", "2.0" ]))
          .to include(name: "Blue Bottle")
      end

      it "casts x and y to Float" do
        result = subject.call([ "Shop", "10", "20" ])
        expect(result[:x]).to eq(10.0)
        expect(result[:y]).to eq(20.0)
      end
    end

    context "with a nil name" do
      it "returns nil for name without raising" do
        expect(subject.call([ nil, "1.0", "2.0" ])).to include(name: nil)
      end
    end

    context "with an invalid x value" do
      it "returns nil" do
        expect(subject.call([ "Shop", "not_a_number", "2.0" ])).to be_nil
      end
    end

    context "with an invalid y value" do
      it "returns nil" do
        expect(subject.call([ "Shop", "1.0", "not_a_number" ])).to be_nil
      end
    end
  end
end
