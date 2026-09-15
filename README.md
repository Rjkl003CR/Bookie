# 🚌 Bookie — Hybrid Bus Ticket Booking Platform

**Bookie** is a full-stack, educational bus ticket booking application featuring a Progressive Web App (PWA) interface, automated refund processing, role-based access control, and an integrated AI support chatbot.

The architecture decouples responsibilities between a modern **Next.js** frontend and a robust **Ruby on Rails** backend API.



##  Key Features

* **Progressive Web App (PWA):** Mobile-installable application with offline caching for bus timetables, saved tickets, and route schedules.

* **JWT & Role-Based Access (RBAC):** Tailored dashboards and API security for **Passengers**, **Bus Owners**, and **System Admins**.

* **Anti-Double Booking Engine:** Pessimistic row locking (`SELECT FOR UPDATE`) in PostgreSQL ensures no two users can book the same seat simultaneously.

* **Automated Payments & Refunds:** Seamless integration with Stripe API (Test Mode) supporting automatic instant refunds upon booking cancellation.

* **AI Chatbot Assistant:** Real-time streaming assistant built with the Vercel AI SDK to answer route inquiries and policy questions.



## Architecture & Tech Stack

| **Frontend Framework** | Next.js (App Router, TypeScript) |
| **Styling & UI** | Tailwind CSS + `shadcn/ui` |
| **PWA Engine** | `@ducanh2912/next-pwa` |
| **AI Integration** | Vercel AI SDK (`ai/react`) |
| **Backend API Framework** | Ruby on Rails (API Mode) |
| **Authentication** | Devise + `devise-jwt` |
| **Database** | PostgreSQL (`pgvector` for AI embeddings) |
| **Background Jobs & Cache** | Redis + Sidekiq |
| **Payment Gateway** | Stripe API (Test Mode) |



##  User Roles & Capabilities

* ** Passenger:** Search routes, interact with live seat maps, purchase tickets, view timetables offline, chat with AI, and self-cancel bookings for instant refunds.

* ** Bus Owner:** Manage bus fleets, configure seating layouts, publish routes and timetables, set fares, and view passenger manifests.

* ** System Admin:** Oversee platform analytics, approve/audit bus operators, manage global service fees, and resolve system disputes.


Designed & Developed with ❤️ by Chamathka Ranathunga & Induwara Umayanga.

