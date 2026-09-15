class Schedule < ApplicationRecord
  belongs_to :bus
  belongs_to :route
  has_many :bookings, dependent: :destroy

  validates :departure_time, :arrival_time, :fare, presence: true

  scope :filter_by, ->(params) {
    scope = all
    scope = scope.joins(:route).where(routes: { origin: params[:origin] }) if params[:origin].present?
    scope = scope.joins(:route).where(routes: { destination: params[:destination] }) if params[:destination].present?
    scope = scope.where("DATE(departure_time) = ?", params[:date]) if params[:date].present?
    scope
  }
end
