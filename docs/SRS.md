# Software Requirements Specification (SRS)

## 1. Introduction

### 1.1 Purpose
This document specifies the functional and non-functional requirements for the **Bookie Bus Ticket Booking System**, an educational hybrid platform with:
- **Next.js PWA frontend**
- **Ruby on Rails API backend**
- **PostgreSQL + Redis**
- **AI support assistant**

### 1.2 Architecture Overview
The platform follows a **Backend-for-Frontend (BFF)** style:
- **Frontend (Next.js)**: UI, seat map rendering, PWA installability/offline behavior, and AI chat streaming.
- **Backend (Rails API)**: business rules, JWT + RBAC authorization, seat locking, Stripe payment/refund flows, Sidekiq jobs.
- **Data layer**: PostgreSQL (including `pgvector` for retrieval use cases), Redis for queueing/session/hold state.

---

## 2. Roles & Access Matrix

| Capability | Passenger | Bus Owner | Admin |
|---|---:|---:|---:|
| Search routes/schedules | ✅ | ✅ | ✅ |
| Book/cancel own tickets | ✅ | ❌ | ❌ |
| Manage buses/schedules/fares | ❌ | ✅ | ✅ |
| View fleet analytics/revenue | ❌ | ✅ | ✅ |
| Approve owner accounts | ❌ | ❌ | ✅ |
| Configure platform fee/refund policy | ❌ | ❌ | ✅ |
| Audit platform activity | ❌ | ❌ | ✅ |

Role values in JWT claims:
- `passenger`
- `bus_owner`
- `admin`

---

## 3. Functional Requirements

### 3.1 Authentication & Authorization
- **FR-AUTH-01**: Backend issues secure JWTs on login (e.g., `devise-jwt`).
- **FR-AUTH-02**: JWT contains role claim (`passenger`, `bus_owner`, `admin`).
- **FR-AUTH-03**: Frontend attaches a JWT bearer token to every protected API request.
- **FR-AUTH-04**: `/api/v1/owner/*` and `/api/v1/admin/*` enforce role authorization (Pundit/CanCanCan policy checks).

### 3.2 Seat Reservation / Anti Double Booking
- **FR-BOOK-01**: Frontend provides graphical seat-map selection.
- **FR-BOOK-02**: Backend uses DB pessimistic locking (`SELECT ... FOR UPDATE`) during seat-hold/checkout.
- **FR-BOOK-03**: Seat hold expires automatically after configured TTL (default 10 minutes) via Redis-backed hold tracking.

### 3.3 Payments & Refunds
- **FR-PAY-01**: Stripe test-mode integration for card payments.
- **FR-PAY-02**: On payment success, booking transitions `pending -> confirmed`; ticket event generated.
- **FR-PAY-03**: Passenger can request cancellation from account dashboard.
- **FR-PAY-04**: Valid cancellations trigger automatic `Stripe::Refund.create` flow.

### 3.4 PWA & Offline Support
- **FR-PWA-01**: PWA compliance via manifest + service worker (`@ducanh2912/next-pwa`).
- **FR-PWA-02**: Install prompt for desktop/mobile where supported.
- **FR-PWA-03**: Timetables, route metadata, and active tickets cached in browser storage/IndexedDB.
- **FR-PWA-04**: Service worker serves cached data and avoids uncaught exceptions when offline.

### 3.5 AI Customer Assistant
- **FR-AI-01**: Embedded chat UI with Vercel AI SDK (`ai/react`).
- **FR-AI-02**: Answers common passenger questions (routes, schedules, baggage, refunds).
- **FR-AI-03**: Uses tool/function calls to query backend for live schedules and availability.

---

## 4. Non-Functional Requirements

### 4.1 Performance
- Schedule and seat-availability endpoints should target **< 200ms** response time under normal load.
- Concurrent booking attempts for the same seat must not create race conditions or deadlocks.

### 4.2 Security
- All traffic must use TLS/HTTPS.
- Passwords must be bcrypt-hashed at rest.
- Owner/Admin endpoints must strictly validate JWT role claims and authorization policies.

### 4.3 Reliability & Availability
- Checkout operations use transactions; failures in lock/payment steps trigger full rollback.
- Offline fallback paths return cached data gracefully when network is unavailable.

---

## 5. Implementation Checklist

### Backend (Rails API)
- [ ] JWT authentication configured with role claim serialization.
- [ ] RBAC policies for passenger/owner/admin paths.
- [ ] Seat-hold transaction uses row-level lock and expiry handling.
- [ ] Stripe payment intent + webhook confirmation + refund service.
- [ ] Sidekiq workers for hold expiry and async notifications.

### Frontend (Next.js PWA)
- [ ] Auth token attachment in API client.
- [ ] Seat map UI with hold countdown and lock errors.
- [ ] PWA manifest and service worker caching strategy.
- [ ] Offline timetable/ticket retrieval from IndexedDB/local cache.
- [ ] AI chat with streaming responses and backend tool calls.

### Data & Infrastructure
- [ ] PostgreSQL schema for users, buses, schedules, bookings, payments, refunds.
- [ ] Redis configured for hold TTL/session/cable usage.
- [ ] Observability and audit logs for booking/payment/refund actions.

---

## 6. Acceptance Criteria (Verifiable)
- Two concurrent booking attempts for the same seat result in one success and one deterministic conflict response.
- Expired seat hold is automatically released and becomes bookable again.
- Successful Stripe payment confirms booking and generates ticket artifact.
- Valid cancellation produces automatic refund request to Stripe.
- Offline mode serves last-synced timetables/tickets without uncaught runtime exception.
- Role-protected owner/admin endpoints deny incorrect role claims with authorization errors.
