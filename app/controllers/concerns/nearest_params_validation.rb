# frozen_string_literal: true

module NearestParamsValidation
  extend ActiveSupport::Concern

  COORDINATE_PARAMS = %i[x y].freeze

  private

  def validate_nearest_params!
    missing = COORDINATE_PARAMS.reject { |k| params[k].present? }
    raise ActionController::BadRequest, "Missing required params: #{missing.join(', ')}" if missing.any?

    COORDINATE_PARAMS.each { |k| cast_param!(k, cast: :Float) }

    if params[:limit].present?
      limit = cast_param!(:limit, cast: :Integer)
      raise ActionController::BadRequest, "limit must be a positive integer greater than 0" unless limit.positive?
    end
  end

  def cast_param!(key, cast:)
    send(cast, params[key])
  rescue ArgumentError
    raise ActionController::BadRequest, "Invalid value for param: #{key}"
  end
end
