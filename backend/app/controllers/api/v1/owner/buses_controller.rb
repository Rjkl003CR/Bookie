module Api
  module V1
    module Owner
      class BusesController < ApplicationController
        before_action :authorize_owner!
        before_action :set_bus, only: [:show, :update, :destroy]

        def index
          @buses = current_user.buses
          render json: BusSerializer.new(@buses).serializable_hash
        end

        def show
          render json: BusSerializer.new(@bus).serializable_hash
        end

        def create
          @bus = current_user.buses.build(bus_params)
          if @bus.save
            render json: BusSerializer.new(@bus).serializable_hash, status: :created
          else
            render json: { errors: @bus.errors }, status: :unprocessable_entity
          end
        end

        def update
          if @bus.update(bus_params)
            render json: BusSerializer.new(@bus).serializable_hash
          else
            render json: { errors: @bus.errors }, status: :unprocessable_entity
          end
        end

        def destroy
          @bus.destroy
          head :no_content
        end

        private

        def set_bus
          @bus = current_user.buses.find(params[:id])
        end

        def bus_params
          params.require(:bus).permit(:name, :plate_number, :total_seats, :layout_json)
        end

        def authorize_owner!
          render json: { error: "Forbidden" }, status: :forbidden unless current_user.bus_owner?
        end
      end
    end
  end
end
