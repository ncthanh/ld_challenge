module Api
  module V1
    class OrdersController < Api::BaseController
      def index
        render plain: "OK!"
      end
    end
  end
end
