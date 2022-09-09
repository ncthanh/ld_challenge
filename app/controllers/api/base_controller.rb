module Api
  class BaseController < ApplicationController
    skip_before_action :verify_authenticity_token

    rescue_from ActionController::ParameterMissing, with: :param_missing

    private

    def param_missing
      render json: { errors: ["Parameter missing"] }, status: :bad_request
    end
  end
end
