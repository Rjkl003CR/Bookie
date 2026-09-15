module Api
  module V1
    class SchedulesController < ApplicationController
      skip_before_action :authenticate_user!, only: [:index, :show]

      # GET /api/v1/schedules
      def index
        @schedules = Schedule.includes(:route, :bus).filter_by(params.permit(:origin, :destination, :date))
        render json: ScheduleSerializer.new(@schedules).serializable_hash
      end

      # GET /api/v1/schedules/:id
      def show
        @schedule = Schedule.find(params[:id])
        render json: ScheduleSerializer.new(@schedule).serializable_hash
      end
    end
  end
end
