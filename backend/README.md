# Bookie Backend — Ruby on Rails API

This is the Rails API backend for the Bookie bus ticket booking platform.

## Stack
- Ruby on Rails 7.2 (API mode)
- PostgreSQL + `pgvector`
- Redis + Sidekiq
- Devise + `devise-jwt` (RBAC)
- Pundit (authorization policies)
- Stripe API
- RSpec + FactoryBot

## Setup (once Ruby 3.3 + Rails 7.2 + PostgreSQL installed)

```bash
cd backend

# Install dependencies
bundle install

# Copy and fill in env vars
cp .env.example .env

# Create and migrate the database
rails db:create db:migrate

# Start the server
rails server -p 3001
```

## Running Sidekiq (background workers)
```bash
bundle exec sidekiq
```

## Running Tests
```bash
bundle exec rspec
```
