module Api
  module V1
    class SessionsController < Api::BaseController
      def create
        user = User.find_by(username: params[:username])
        if user&.authenticate(params[:password])
          render json: { message: "Success" }, status: :ok
        else
          render json: { errors: ["Invalid username or password"] }, status: :unauthorized
        end
      end
    end
  end
end
