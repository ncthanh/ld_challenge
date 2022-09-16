module Api
  module V1
    class SessionsController < Api::BaseController
      skip_before_action :ensure_authorized

      def create
        user = User.find(params[:username])
        if user&.authenticate(params[:password])
          render json: { message: "success", token: AuthTokenManager.generate_token(user) }, status: :ok
        else
          render json: { errors: ["Invalid username or password"] }, status: :unauthorized
        end
      end
    end
  end
end
