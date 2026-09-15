# 👥 Bookie — Team Workload Allocation

> **Team**: Chamathka Ranathunga · Induwara Umayanga · You (3 members)
> **Goal**: Equally-scoped workload across Backend, Frontend, and Infrastructure+AI

---

## Overview

| Domain | Assignee | % Load |
|---|---|---|
| 🛤️ Backend Core (Auth, RBAC, Bookings, DB) | **Chamathka Ranathunga** | ~33% |
| 🎨 Frontend Core (UI, PWA, Seat Map, Dashboard) | **Induwara Umayanga** | ~33% |
| 🤖 AI + Payments + Infrastructure | **You** | ~33% |

---

## 👤 Chamathka Ranathunga — Backend Core

**Responsible for the Rails API backbone and data integrity.**

### Auth & RBAC
- [ ] Set up Devise + `devise-jwt` with role claim in JWT payload (`FR-AUTH-01`, `FR-AUTH-02`)
- [ ] Implement Pundit policies for Passenger, Bus Owner, and Admin routes (`FR-AUTH-04`)
- [ ] Write API endpoint for `POST /api/v1/login`, `DELETE /api/v1/logout`, `POST /api/v1/signup`

### Seat Booking Engine
- [ ] Implement `BookingService` with pessimistic row-level locking (`SELECT FOR UPDATE`) (`FR-BOOK-02`)
- [ ] Implement `SeatHoldExpiryWorker` (Sidekiq) to auto-expire seat holds after 10 minutes (`FR-BOOK-03`)
- [ ] Write acceptance tests verifying concurrent seat booking conflict resolution

### Bus Owner Management API
- [ ] `Owner::BusesController` — CRUD for bus fleets
- [ ] `Owner::SchedulesController` — publish/update/delete schedules
- [ ] `Owner::FaresController` — manage fares per schedule
- [ ] `Owner::AnalyticsController` — revenue and passenger manifest endpoints

### Database
- [ ] Write and run all database migrations (users, buses, seats, schedules, bookings, payments)
- [ ] Enable `pgvector` extension migration
- [ ] Write database seeds for dev/test environments

### Testing
- [ ] RSpec unit tests for `BookingService`, `SeatHoldExpiryWorker`, Pundit policies
- [ ] Request specs for auth and booking endpoints

---

## 👤 Induwara Umayanga — Frontend Core

**Responsible for the Next.js PWA and passenger-facing UI.**

### Authentication UI
- [ ] Sign up / Login / Logout pages with JWT token storage (`FR-AUTH-03`)
- [ ] Protected route middleware for passenger, owner, and admin areas

### Seat Map & Booking Flow
- [ ] Graphical seat-map component (seat grid from bus layout JSON) (`FR-BOOK-01`)
- [ ] Seat hold countdown timer UI (10-minute TTL display)
- [ ] Booking confirmation and conflict-error handling screens

### Passenger Dashboard
- [ ] Active and past bookings list
- [ ] Ticket detail view (QR / ticket artifact)
- [ ] Cancellation flow with confirmation dialog

### PWA & Offline Support
- [ ] Configure `@ducanh2912/next-pwa` with manifest + service worker (`FR-PWA-01`, `FR-PWA-02`)
- [ ] Cache timetables, route metadata, and active tickets in IndexedDB (`FR-PWA-03`)
- [ ] Offline fallback pages that serve cached data gracefully (`FR-PWA-04`)

### Bus Owner Dashboard (UI)
- [ ] Fleet management page (buses CRUD)
- [ ] Schedule publishing form
- [ ] Revenue analytics chart

### Testing
- [ ] Jest unit tests for seat-map component
- [ ] Playwright/Cypress E2E test: full booking flow (search → seat select → pay)

---

## 👤 You — AI Assistant + Payments + Infrastructure

**Responsible for AI chatbot integration, Stripe flows, and DevOps.**

### AI Customer Assistant
- [ ] Build AI chat UI using Vercel AI SDK (`ai/react`) with streaming responses (`FR-AI-01`)
- [ ] Implement tool/function calls from the AI to query live schedule & availability endpoints (`FR-AI-03`)
- [ ] Craft system prompt for Bookie assistant (routes, schedules, baggage policy, refund policy) (`FR-AI-02`)
- [ ] Backend `ChatController` + `ChatService` (RAG with pgvector embeddings optional)

### Payments & Refunds
- [ ] Integrate Stripe payment intent creation at booking checkout (`FR-PAY-01`)
- [ ] Implement Stripe webhook handler for payment confirmation → `pending → confirmed` (`FR-PAY-02`)
- [ ] Implement `CancellationService` → `Stripe::Refund.create` flow (`FR-PAY-04`)
- [ ] Admin dashboard: payment and refund audit log view

### Admin Panel API
- [ ] `Admin::UsersController` — manage users and roles
- [ ] `Admin::OperatorsController` — approve/reject bus owner accounts
- [ ] `Admin::SettingsController` — platform fee and refund policy config
- [ ] `Admin::AuditLogsController` — audit trail for booking/payment/refund events

### Infrastructure & DevOps
- [ ] Write `docker-compose.yml` for local dev (Rails, PostgreSQL, Redis, Sidekiq)
- [ ] Set up `.env.example` and environment variable documentation
- [ ] Configure CORS for Next.js ↔ Rails communication
- [ ] Write deployment README (Render / Railway / fly.io)

### Testing
- [ ] RSpec tests for `CancellationService` (Stripe refund)
- [ ] Webhook handler tests (Stripe payment confirmation)

---

## 🔁 Shared Responsibilities (All 3)

| Task | Notes |
|---|---|
| Code reviews | Review each other's PRs before merge |
| Daily standups | Sync blockers across frontend/backend |
| Git branching strategy | `feature/` branches → `dev` → `main` |
| Documentation | Update `docs/SRS.md` checklist as items complete |
