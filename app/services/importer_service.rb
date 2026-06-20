# frozen_string_literal: true

class ImporterService
    BATCH_SIZE = 1000

    def initialize(importer:, model:)
        @importer = importer
        @model = model
    end

    def call(url)
        records = importer.call(url)

        batch = []

        records.each do |record|
            batch << record

            if batch.size >= BATCH_SIZE
                persist(batch)
                batch.clear
            end
        end

        persist(batch) unless batch.empty?
    end

    private

    attr_reader :importer, :model

    def persist(records)
        model.upsert_all(
            records,
            unique_by: [:x, :y],
            update_only: [:name],
            record_timestamps: true
        )
    end
end
