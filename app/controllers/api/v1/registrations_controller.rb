module Api
  module V1
    class RegistrationsController < Api::BaseController
      def create
        user = User.new(user_params)
        if user.save
          render json: { message: "Success" }, status: :created
        else
          render json: { errors: user.errors }, status: :ok
        end
      end

      private

      def user_params
        params.require(:user).permit(:username, :password, :password_confirmation).tap do |user_params|
          %i[username password password_confirmation].each do |p|
            user_params.require(p)
          end
        end
      end
    end
  end
end
