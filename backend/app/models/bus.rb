class Bus < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_many :schedules, dependent: :destroy
  has_many :seats, dependent: :destroy

  validates :name, :plate_number, :total_seats, presence: true
  validates :plate_number, uniqueness: true
end
