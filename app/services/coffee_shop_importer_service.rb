# frozen_string_literal: true

class CoffeeShopImporterService
    def initialize(importer:)
        @importer = importer
    end

    def call(url)
        records = importer.call(url)

        create_records(records)
    end

    private

    attr_reader :importer

    def create_records(records)
        CoffeeShop.upsert_all(
            records,
            unique_by: [:x, :y],
            update_only: [:name]
        )
    end
end