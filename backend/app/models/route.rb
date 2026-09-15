class Route < ApplicationRecord
  has_many :schedules, dependent: :destroy

  validates :origin, :destination, presence: true
end
