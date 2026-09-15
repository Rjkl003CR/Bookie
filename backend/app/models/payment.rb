class Payment < ApplicationRecord
  belongs_to :booking

  enum status: { pending: 0, succeeded: 1, refunded: 2, failed: 3 }

  validates :stripe_payment_intent_id, presence: true
  validates :amount_cents, presence: true, numericality: { greater_than: 0 }
end
