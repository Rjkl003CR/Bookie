module Api
  module V1
    class BookingsController < ApplicationController
      before_action :set_booking, only: [:show, :destroy]

      # GET /api/v1/bookings
      def index
        @bookings = current_user.bookings.includes(:schedule, :seats)
        render json: BookingSerializer.new(@bookings).serializable_hash
      end

      # GET /api/v1/bookings/:id
      def show
        authorize @booking
        render json: BookingSerializer.new(@booking).serializable_hash
      end

      # POST /api/v1/bookings
      # Acquires pessimistic row lock on seats to prevent double booking (FR-BOOK-02)
      def create
        result = BookingService.new(
          user: current_user,
          schedule_id: params[:schedule_id],
          seat_ids: params[:seat_ids]
        ).call

        if result.success?
          render json: BookingSerializer.new(result.booking).serializable_hash, status: :created
        else
          render json: { errors: result.errors }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/bookings/:id  (cancellation + refund FR-PAY-03/04)
      def destroy
        authorize @booking
        result = CancellationService.new(@booking).call

        if result.success?
          render json: { message: "Booking cancelled and refund initiated." }
        else
          render json: { errors: result.errors }, status: :unprocessable_entity
        end
      end

      private

      def set_booking
        @booking = Booking.find(params[:id])
      end
    end
  end
end
