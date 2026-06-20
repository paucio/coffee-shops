# frozen_string_literal: true

class CoffeeShopImportJob < ApplicationJob
  queue_as :default

  def perform(url)
    ImportService.new(
      importer: build_importer,
      model: CoffeeShop,
      unique_by: [:x, :y],
      update_only: [:name]
    ).call(url)
  end

  private

  def build_importer
    Import::CsvImporter.new(
      downloader: Import::Downloaders::HttpDownloader.new,
      parser: Import::Parsers::CsvParser.new,
      mapper: Import::Mappers::CoffeeShopCsvMapper.new
    )
  end
end
