# ANTFAST Mobile App — Business Requirements Document

## 1. Purpose

This BRD defines the customer-facing ANTFAST mobile product: its users, order lifecycle, business rules, integrations, and acceptance criteria.

The detailed field-level API contract is maintained separately in [current_screen_api_map.csv](current_screen_api_map.csv). 
## 2. Product summary

ANTFAST is a mobile application for customers to plan ready-mix concrete deliveries, configure a concrete order and its site services, pay for it, follow fulfilment, and manage the related project, wallet, documents, invoices, and support activity.

The product supports two account journeys:

| Account type | Journey |
| --- | --- |
| Business | Sign in / create business account → OTP verification → Business KYC → Home |
| Individual | Sign in / create individual account → OTP verification → Home |

The primary user outcome is a paid, fulfilment-ready order with a clear audit trail from project/site selection through delivery completion.

## 3. Goals

- Let customers create and manage concrete-delivery orders without offline coordination for routine steps.
- Collect the exact site, mix, quantity, schedule, structure, and service details needed for fulfilment.
- Show server-calculated pricing and enable the supported payment choices.
- Give the customer visibility into order status, schedule changes, operations agreement, live tracking, delivery proof, and invoices.
- Keep business verification, payment, wallet, and delivery actions traceable and safe.

## 4. Scope

### In scope

- Onboarding, sign in, account creation, OTP verification, passcode reset, and sign out.
- Business KYC status and KYC document-upload journey.
- Home dashboard and bottom tabs: Home, Orders, Projects, Wallet, Profile.
- Projects, project details, saved sites, and add-location flow.
- New cash-order journey, including mix code, quantity, time window, structure type, services, site conditions, review, draft order creation, and price breakdown.
- Payment, split-wallet payment, bank proof upload, payment success/pending state.
- Wallet balance, transaction history, and add funds. Withdrawal is not in product scope.
- Order list/detail, schedule proposal, operations agreement, resources, live tracking, site checkpoint, pouring/loading completion, delivery rating, and order chat.
- Invoices, invoice detail/PDF, QC checkpoint, delivery signatures, profile/company details, documents, notifications, FAQ, and support ticket submission.

### Out of scope for this BRD

- Supplier, driver, dispatcher, finance, KYC-reviewer, or administrator portals.
- A withdrawal flow or cash-out API.
- Reorder.
- A commitment to a particular payment, wallet, messaging, KYC, map, or notification provider.

## 5. Application architecture

The app is Flutter/Dart and follows a feature-based, layered structure: data source → repository → use case → BLoC → screen. Dependency injection is provided by GetIt and state is provided through flutter_bloc.

The application modules are Auth, Home, Orders, Invoices, Wallet, Payment, Profile, Notifications, KYC, Onboarding, and Splash. Each module uses repository boundaries so that mobile UI, backend APIs, local persistence, and provider services remain independently testable.

The mobile platform uses API networking, secure local session storage, push messaging, maps/location, document selection, and responsive-device testing capabilities.

## 6. User journeys and functional requirements

| ID | Area | Requirement / journey | Completion condition |
| --- | --- | --- | --- |
| FR-01 | Launch and onboarding | On first launch, show onboarding; then route the user to Sign In. Returning users follow the splash launch decision. | User reaches the correct next screen. |
| FR-02 | Authentication | Sign in accepts only `usernameOrMobile` and `password`. The Business/Individual selector changes the input label; it must not add sign-up fields to sign-in. | Valid credentials create a session and open the app. |
| FR-03 | Account creation | Business and Individual registrations are separate submissions with their own UI fields and OTP session. | A verification ID is returned and the user reaches Verify Account. |
| FR-04 | OTP and recovery | Verify sign-up OTP, resend it, request a passcode-reset OTP, verify reset OTP, and set a new passcode. | Expired, invalid, rate-limited, and too-many-attempt states are understandable and recoverable. |
| FR-05 | Business KYC | Business users can see KYC status and upload Trade License, optional VAT Certificate, and Authorized Person ID. | KYC state drives allowed capabilities; a pending business can plan orders but cannot make payments until approved. |
| FR-06 | Dashboard and navigation | Home presents the user/company context and active orders. Persistent tabs lead to Home, Orders, Projects, Wallet, and Profile. | Tab state and child navigation retain the correct context. |
| FR-07 | Projects and locations | Users can list/create projects, inspect project details, list saved sites, and add a site with its address/location and contact details. | A selected project and site have stable IDs available to the order journey. |
| FR-08 | Order configuration | User selects a project/site, mix code, quantity, delivery date and **time window**, structure type, requested services, and site conditions. | Review receives the complete selection without losing values between screens. |
| FR-09 | Draft order and pricing | Review submits one draft order. Price Breakdown is retrieved with that returned `orderId`; pricing is never calculated by the client. | Backend returns the exact UI fields: `concrete`, `concretePump`, `technicianAnd6CubeMoulds`, `paymentMethodCharge`, `subtotal`, `vat`, `total`, `currency`. |
| FR-10 | Payment | User chooses Wallet, Card/Payment Link, Bank Transfer, or Cash in Advance where available. Split wallet amount and terms acceptance are validated server-side. | Payment is initiated against the order, then its status is refreshed or updated by provider callback/webhook. |
| FR-11 | Wallet | Show available, reserved, total token m³, estimated AED value, transactions, and add-funds action. | Every wallet movement has a status and transaction record. |
| FR-12 | Order operations | Customer can view order detail/status, schedule proposal, operations agreement, assigned resources, tracking, site checkpoint, pouring/loading state, and delivery completion. | Every resource action uses the selected order's `orderId`; tracking is distinct from order detail. |
| FR-13 | Post-delivery | User can view invoice/QC/signatures, download invoice PDF, send order chat messages, and rate a completed delivery once. | Records are tied to the correct order or invoice ID. |
| FR-14 | Account and support | User can manage personal/company details and documents, view notifications, submit support tickets, request account deletion, and sign out. | Sensitive changes are authenticated, validated, and auditable. |

## 7. End-to-end order lifecycle

```text
Project + saved/new location
        ↓
Mix code → quantity → date/time window → structure/services → site conditions
        ↓
Review → POST /orders (draft orderId)
        ↓
GET /orders/{orderId}/price-breakdown
        ↓
POST /payments → provider / bank-proof path → verified payment
        ↓
Order detail → proposal/agreement/resources → live tracking → delivery
        ↓
QC/signatures/invoice → rating and support if needed
```

Each order has an `orderId`. The review submission creates the order record and returns its `orderId`; every later order action uses that ID. A display reference is not used as a resource identifier.

## 8. Business rules

1. Authentication and registration are separate concerns. Sign-in never sends registration fields. Business and Individual sign-up remain separate APIs because their fields differ.
2. OTP endpoints use a server-issued `verificationId`; phone/contact is only display context after creation.
3. Business KYC status is authoritative from the backend. Payment capability must not rely on only a local UI flag.
4. Project, location, order, payment, invoice, notification, document, and message identifiers must be persisted and passed explicitly across navigation.
5. The review action creates a draft order, not a completed/paid order. Price Breakdown is read by `GET /orders/{orderId}/price-breakdown` after creation.
6. Pricing belongs to the backend. It may change before payment; the user must see the refreshed total and confirm it before proceeding.
7. Date selection and time-window selection are different. The system returns available time windows for the chosen date; the client does not create slots.
8. The server validates ownership, current status, duplicate acceptance/rating/payment, balance, KYC/payment eligibility, and all amounts.
9. Payment success must be confirmed by a trusted backend status or provider webhook, not only a client redirect result.
10. Wallet value is represented as token m³ and estimated AED value. Reserve, debit, top-up, and refund states must be ledgered. Withdrawal is not a product requirement.
11. Schedule proposal and operations agreement acceptance apply to the relevant `orderId` only.
12. Delivery rating is allowed only for a completed order and only once.

## 9. Data and integrations

| Domain | Core records | Integration / ownership requirement |
| --- | --- | --- |
| Identity | user, business profile, session, OTP verification | Auth service plus SMS/OTP provider; secure token storage and refresh/logout handling. |
| KYC | KYC status, document metadata, document file ID, review result | KYC provider and object storage; server controls review outcome. |
| Project/site | project, saved location, coordinates, address, site contact | Maps/geocoding may assist address selection; backend owns saved record IDs. |
| Ordering | mix code, quantity, schedule, structure, services, conditions, draft order | Order/pricing backend owns validation, availability, status, and price. |
| Payments/wallet | payment, provider reference, top-up, wallet ledger transaction | A payment gateway and, if used, a compliant wallet programme provider. Provider selection and operating permissions are release dependencies. |
| Delivery | resources, tracking coordinates/events, proposal, agreement, QC, signatures | Fulfilment/operations service; real-time updates may use push or streaming. |
| Customer comms | notification, support ticket, message | Firebase/push and optional real-time messaging provider. |
| Documents/invoices | uploaded document, invoice, PDF, proof, signature | Secure object storage with time-limited access URLs. |

## 10. Non-functional requirements

- **Responsive mobile UI:** Preserve usable layout, tap targets, scrolling, keyboard behavior, and text visibility on supported phone/tablet widths. Device Preview assists development but physical-device testing remains mandatory.
- **Security:** TLS for all traffic; authenticated APIs; secure handling of access/refresh tokens; no card data stored in the app; signed/time-limited document URLs; server-side authorization on every resource ID.
- **Reliability:** Explicit loading, empty, retry, offline, validation, expired-session, and provider-unavailable states.
- **Data integrity:** Idempotency for order creation, top-ups, and payments; server-side amount calculation; audit trails for payment/KYC/wallet/order status changes.
- **Performance:** Paginate orders, transactions, messages, notifications, and invoices; avoid blocking navigation on non-critical content; cache safe read-only data only.
- **Observability:** Crash/error reporting, request correlation IDs, payment/webhook audit logs, and operational dashboards before production release.
- **Privacy and retention:** Restrict access to KYC files, identity documents, payment proof, and location data; define retention/deletion policy before launch.

## 11. Delivery prerequisites

| Priority | Gap | Required decision or work |
| --- | --- | --- |
| P0 | Platform connectivity and sessions | Production API clients, real connectivity handling, secure session persistence, and test environments. |
| P0 | Cross-screen order state | Use a single draft-order model/BLoC or persisted draft so selected values and IDs survive every step. |
| P0 | Payment/KYC/wallet provider | Select providers, confirm contractual/compliance operating model, implement sandbox/webhook reconciliation, and document failure handling. |
| P0 | Backend authorization and lifecycle | Enforce account, KYC, project/location ownership, payment, order, proposal, and agreement states on the server. |
| P1 | Files and documents | Implement file picker/upload progress, signed upload/download URLs, file validation, and retention controls. |
| P1 | Tracking and notifications | Connect live delivery events and push notifications; define fallback polling and stale-location messaging. |
| P1 | Form and route integration | Connect forms to validation and APIs; preserve the correct flow after each completed action. |
| P2 | Analytics and support operations | Instrument funnel and error events; define support-ticket routing and service-level expectations. |

## 12. Acceptance and success measures

The MVP is acceptable when a new customer can complete the active journey on a supported device: create the correct account type, verify OTP, complete the required KYC path, create a project/site, create a draft order, retrieve server pricing, complete or correctly pend a payment, and subsequently find and follow that order from the Orders tab.

Suggested operational measures:

- Sign-up-to-OTP-verification completion rate.
- Draft-order-to-payment-initiation and payment-success rate.
- Pricing/payment mismatch and duplicate-payment rate (target: zero unresolved).
- KYC review time and payment-block reason distribution.
- Delivery tracking freshness, successful invoice availability, and support ticket resolution time.
- Crash-free sessions and API error rate by screen/endpoint.
