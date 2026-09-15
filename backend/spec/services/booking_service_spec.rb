require "rails_helper"

RSpec.describe BookingService do
  let(:user) { create(:user, role: :passenger) }
  let(:schedule) { create(:schedule) }
  let(:seat) { create(:seat, bus: schedule.bus) }

  context "when seat is available" do
    it "creates a confirmed pending booking" do
      result = described_class.new(user: user, schedule_id: schedule.id, seat_ids: [seat.id]).call
      expect(result.success?).to be true
      expect(result.booking.pending?).to be true
    end
  end

  context "when seat is already booked" do
    before { described_class.new(user: create(:user), schedule_id: schedule.id, seat_ids: [seat.id]).call }

    it "returns a conflict error" do
      result = described_class.new(user: user, schedule_id: schedule.id, seat_ids: [seat.id]).call
      expect(result.success?).to be false
      expect(result.errors).to include("One or more seats are already booked.")
    end
  end
end
