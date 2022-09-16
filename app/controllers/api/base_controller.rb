module Api
  class BaseController < ApplicationController
    before_action :ensure_authorized
    skip_before_action :verify_authenticity_token

    rescue_from ActionController::ParameterMissing, with: :param_missing

    private

    def ensure_authorized
      header = request.headers["AUTHORIZATION"]
      token = header&.gsub(/\AToken\s/, "")
      render json: { errors: ["Authorization failed"] }, status: :unauthorized and return unless AuthTokenManager.locate_user(token)
    end

    def param_missing
      render json: { errors: ["Parameter missing"] }, status: :bad_request
    end
  end
end
