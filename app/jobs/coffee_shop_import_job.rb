# frozen_string_literal: true

class CoffeeShopImportJob < ApplicationJob
  queue_as :default

  def perform(url)
    ImporterService.new(importer: build_importer, model: CoffeeShop).call(url)
  end

  private

  def build_importer
    Importer::CsvImporter.new(
      downloader: Importer::Downloaders::HttpDownloader.new,
      parser: Importer::Parsers::CsvParser.new
    )
  end
end
