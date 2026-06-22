# frozen_string_literal: true

# Job to import coffee shop data from a CSV file located at a given URL.
# The job will download the CSV, parse it, map the data to the CoffeeShop model and perform a bulk upsert operation.
# After persisting the data, it will also index the coffee shops into a grid for efficient querying.
class CoffeeShopImportJob < ApplicationJob
  queue_as :coffee_shop_queue

  retry_on Import::Errors::DownloadError, Faraday::ConnectionFailed, Faraday::TimeoutError,
         wait: 1.minute, attempts: 3

  def perform(url)
    Import::BulkUpsert.new(
      importer: build_pipeline,
      model: CoffeeShop,
      unique_by: [ :x, :y ],
      update_only: [ :name ],
      after_persist: Import::GridIndexer.new(grid: Finder::Grids::CoffeeShop).method(:multi_index)
    ).call(url)
  end

  private

  def build_pipeline
    Import::Pipeline.new(
      downloader: Import::Downloaders::HttpDownloader.new,
      parser: Import::Parsers::CsvParser.new,
      mapper: Import::Mappers::CoffeeShopCsvMapper.new
    )
  end
end
