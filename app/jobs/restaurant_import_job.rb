# frozen_string_literal: true

class RestaurantImportJob < ApplicationJob
	queue_as :restaurants_queue

	retry_on Import::Errors::DownloadError, Faraday::ConnectionFailed, Faraday::TimeoutError,
			wait: 1.minute, attempts: 3

	def perform(url)
		Import::BulkUpsert.new(
			importer: build_pipeline,
			model: Restaurant,
			unique_by: [ :x, :y ],
			update_only: [ :name ],
			after_persist: Import::GridIndexer.new(grid: Finder::Grids::Restaurant).method(:multi_index)
		).call(url)
	end

	private

	def build_pipeline
		Import::Pipeline.new(
			downloader: Import::Downloaders::HttpDownloader.new,
			parser: Import::Parsers::CsvParser.new,
			mapper: Import::Mappers::RestaurantMapper.new
		)
	end
end