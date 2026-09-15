class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :schedule
  has_many :booking_seats, dependent: :destroy
  has_many :seats, through: :booking_seats
  has_one :payment, dependent: :destroy

  # pending -> confirmed -> cancelled
  enum status: { pending: 0, confirmed: 1, cancelled: 2 }

  validates :status, presence: true
end
