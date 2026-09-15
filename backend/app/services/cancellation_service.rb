# CancellationService
# Handles booking cancellation and triggers automatic Stripe refund (FR-PAY-03, FR-PAY-04)
class CancellationService
  Result = Struct.new(:success?, :errors)

  def initialize(booking)
    @booking = booking
  end

  def call
    ActiveRecord::Base.transaction do
      payment = @booking.payment

      unless payment&.stripe_payment_intent_id
        return Result.new(false, ["No payment found for this booking."])
      end

      # Trigger Stripe refund
      Stripe::Refund.create(
        payment_intent: payment.stripe_payment_intent_id
      )

      payment.update!(status: :refunded)
      @booking.update!(status: :cancelled)

      Result.new(true, [])
    end
  rescue Stripe::StripeError => e
    Result.new(false, [e.message])
  end
end
