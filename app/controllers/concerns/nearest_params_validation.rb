# frozen_string_literal: true

module NearestParamsValidation
  extend ActiveSupport::Concern

  COORDINATE_PARAMS = %i[x y].freeze

  private

  def validate_nearest_params!
    missing = COORDINATE_PARAMS.reject { |k| params[k].present? }
    raise ActionController::BadRequest, "Missing required params: #{missing.join(', ')}" if missing.any?

    COORDINATE_PARAMS.each do |k|
      Float(params[k])
    rescue ArgumentError
      raise ActionController::BadRequest, "Invalid value for param: #{k}"
    end

    if params[:limit].present?
      limit = Integer(params[:limit])
      raise ActionController::BadRequest, "limit must be a positive integer greater than 0" unless limit.positive?
    rescue ArgumentError
      raise ActionController::BadRequest, "Invalid value for param: limit"
    end
  end
end
