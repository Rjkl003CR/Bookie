# SeatHoldExpiryWorker
# Sidekiq worker that expires stale seat holds (FR-BOOK-03)
class SeatHoldExpiryWorker
  include Sidekiq::Worker

  sidekiq_options queue: :default, retry: 3

  def perform(booking_id)
    booking = Booking.find_by(id: booking_id)
    return unless booking&.pending?

    booking.update!(status: :cancelled)
    Rails.logger.info "[SeatHoldExpiryWorker] Booking #{booking_id} expired and cancelled."
  end
end
