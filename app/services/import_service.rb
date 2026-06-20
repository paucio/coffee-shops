# frozen_string_literal: true

class ImportService
  BATCH_SIZE = 1000

  def initialize(importer:, model:, unique_by:, update_only:)
    @importer    = importer
    @model       = model
    @unique_by   = unique_by
    @update_only = update_only
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

  attr_reader :importer, :model, :unique_by, :update_only

  def persist(records)
    model.upsert_all(
      records,
      unique_by: unique_by,
      update_only: update_only,
      record_timestamps: true
    )
  end
end
