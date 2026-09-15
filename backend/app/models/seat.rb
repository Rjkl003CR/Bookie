class Seat < ApplicationRecord
  belongs_to :bus
  has_many :booking_seats, dependent: :destroy
  has_many :bookings, through: :booking_seats

  validates :seat_number, presence: true, uniqueness: { scope: :bus_id }
end
