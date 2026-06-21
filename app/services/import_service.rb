# frozen_string_literal: true

class ImportService
  BATCH_SIZE = 1000

  def initialize(importer:, model:, unique_by:, update_only:, after_persist:)
    @importer      = importer
    @model         = model
    @unique_by     = unique_by
    @update_only   = update_only
    @after_persist = after_persist
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

  attr_reader :importer, :model, :unique_by, :update_only, :after_persist

  def persist(records)
    result = model.upsert_all(
      records,
      unique_by: unique_by,
      update_only: update_only,
      record_timestamps: true,
      returning: [ :id, :x, :y ]
    )

    after_persist.call(result)
  end
end
