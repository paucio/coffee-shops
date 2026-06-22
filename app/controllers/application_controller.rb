class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  rescue_from ActiveRecord::StatementInvalid, with: :service_unavailable

  rescue_from ActionController::BadRequest do |exception|
    render json: { error: exception.message }, status: :bad_request
  end

  private

  def service_unavailable
    render json: { error: "Service unavailable" }, status: :service_unavailable
  end
end