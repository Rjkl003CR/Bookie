module Api
  module V1
    class RoutesController < ApplicationController
      skip_before_action :authenticate_user!, only: [:index, :show]

      # GET /api/v1/routes
      def index
        @routes = Route.all
        render json: RouteSerializer.new(@routes).serializable_hash
      end

      # GET /api/v1/routes/:id
      def show
        @route = Route.find(params[:id])
        render json: RouteSerializer.new(@route).serializable_hash
      end
    end
  end
end
