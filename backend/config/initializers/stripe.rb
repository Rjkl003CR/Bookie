Stripe.api_key = Rails.application.credentials.stripe_secret_key || ENV["STRIPE_SECRET_KEY"]
