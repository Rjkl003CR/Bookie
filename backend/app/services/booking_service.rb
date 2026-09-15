# BookingService
# Handles seat reservation with pessimistic locking to prevent double booking (FR-BOOK-02)
# Creates a seat hold in Redis with TTL (FR-BOOK-03)
class BookingService
  Result = Struct.new(:success?, :booking, :errors)

  SEAT_HOLD_TTL = 10.minutes

  def initialize(user:, schedule_id:, seat_ids:)
    @user = user
    @schedule_id = schedule_id
    @seat_ids = seat_ids
  end

  def call
    ActiveRecord::Base.transaction do
      # Pessimistic row lock to prevent double booking
      seats = Seat.where(id: @seat_ids).lock("SELECT * FROM seats WHERE id IN (?) FOR UPDATE", @seat_ids)

      if seats_already_booked?(seats)
        return Result.new(false, nil, ["One or more seats are already booked."])
      end

      booking = Booking.create!(
        user: @user,
        schedule_id: @schedule_id,
        status: :pending
      )

      seats.each { |seat| booking.booking_seats.create!(seat: seat) }

      # Hold seat in Redis with TTL (FR-BOOK-03)
      hold_seats_in_redis(booking.id, @seat_ids)

      Result.new(true, booking, [])
    end
  rescue ActiveRecord::RecordInvalid => e
    Result.new(false, nil, [e.message])
  end

  private

  def seats_already_booked?(seats)
    seats.joins(:bookings).where(bookings: { status: [:pending, :confirmed], schedule_id: @schedule_id }).exists?
  end

  def hold_seats_in_redis(booking_id, seat_ids)
    redis = Redis.new(url: ENV["REDIS_URL"])
    seat_ids.each do |seat_id|
      redis.setex("seat_hold:#{@schedule_id}:#{seat_id}", SEAT_HOLD_TTL, booking_id)
    end
  end
end
