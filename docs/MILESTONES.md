# ANTFAST Mobile App — Delivery Milestones

This plan builds the customer-facing product in dependency order. Each milestone is complete only after its acceptance criteria are met in a test environment.

| Milestone | Outcome | Main deliverables | Dependencies | Exit criteria |
| --- | --- | --- | --- | --- |
| M0 — Product and contract baseline | One agreed product baseline | Confirm navigation and user journeys; freeze UI field names; approve [API map](current_screen_api_map.csv); define order/payment/KYC state diagrams | Product, design, backend, operations | Every product screen has an owner, API contract, loading/error/empty behavior, and stable IDs. |
| M1 — Platform and session foundation | App can safely start and maintain a real session | Environment config, Dio/Retrofit clients, auth interceptor/token refresh, secure persistence, real network status, common API error mapper, logging | Backend auth sandbox | Splash, onboarding, sign in, sign out, forgot/reset passcode work against backend; expired sessions return cleanly to sign in. |
| M2 — Registration and business verification | Correct accounts can enter the product | Separate Business/Individual registration, OTP verify/resend, Business KYC status, document upload, capability gating | SMS provider; KYC/object-storage sandbox | Business and Individual payloads remain separate; OTP error states work; business payment is blocked until backend says KYC approved. |
| M3 — Projects, sites, and order inputs | Customer can prepare a valid order | Project CRUD/read scope, saved sites/add location, map/address handling, mix codes, date-specific time windows, structure/services/site-condition input models | Project/order catalogue backend; maps decision | Project and location IDs survive navigation; all selected order inputs appear unchanged on Review. |
| M4 — Order creation and server pricing | One authoritative order and total | `POST /orders`, order ID persistence, `GET /orders/{orderId}/price-breakdown`, price-change re-confirmation, validation/idempotency | Order/pricing backend | Review creates exactly one order per confirmed action; UI displays the approved Price Breakdown labels; no price is calculated in Flutter. |
| M5 — Payments and wallet | Customer can pay and see accurate wallet state | Payment initiation/status, provider redirect/link handling, split wallet, bank-transfer proof, top-up, wallet balance/ledger, webhook reconciliation | Payment gateway; wallet programme/operating model; KYC gating | Payment is confirmed only by backend/provider status; failed/pending/retry paths work; every wallet movement has a transaction record. |
| M6 — Fulfilment and customer visibility | Customer can follow the paid order | Orders list/detail/status, schedule proposal and acceptance, operations agreement and acceptance, assigned resources, tracking, checkpoint/pouring/loading, notifications | Operations backend; tracking event source; push setup | Every operation is tied to `orderId`; proposal/agreement cannot be accepted twice; tracking shows a clear stale/unavailable state. |
| M7 — Completion, records, and support | Delivery closes with customer records | Invoice list/detail/PDF, QC, delivery signatures, rating, order chat, profile/company/documents, notifications, support, account-deletion request | Invoice/document services; messaging decision; support process | Completed orders expose their records where available; rating is one-time; protected documents use secure access URLs. |
| M8 — Quality, UAT, and release | Stable production-ready MVP | Device/responsive matrix, integration/E2E tests, security review, provider/webhook failure drills, performance checks, analytics, app-store release preparation, runbooks | All prior milestones | UAT signs off the complete journey; P0 defects are closed; monitoring and support ownership are live. |

## Build sequence and ownership

```text
M0 product baseline
  → M1 session foundation
  → M2 account + KYC
  → M3 project/site/order inputs
  → M4 order creation + pricing
  → M5 payment + wallet
  → M6 operations + tracking
  → M7 records + support
  → M8 UAT + release
```

Some discovery may run in parallel, but M4 must not finish before order IDs and server pricing are authoritative; M5 must not launch before provider/webhook handling and KYC rules are verified.

| Workstream | Primary responsibilities |
| --- | --- |
| Product/design | Finalize navigation, UI content, business rules, edge states, and UAT scenarios. |
| Flutter | Connect repositories/API clients, preserve order IDs through routes/BLoC, implement loading/error states, secure local session behavior, and device validation. |
| Backend | Implement the approved API map, validation/error codes, authorization, state machines, pricing, idempotency, webhooks, audit logs, and data retention controls. |
| Operations | Define mix/service availability, proposal/agreement workflow, tracking event source, QC/signature responsibility, invoice readiness, and support escalation. |
| Compliance/provider owner | Confirm KYC, payment, wallet/top-up, and data-handling operating model with selected providers before go-live. |
| QA | API contract, regression, E2E, responsive, offline/error, payment callback/webhook, security, and release testing. |

## Mandatory milestone gates

1. **Before M3:** approve the screen list and field-level API map.
2. **Before M4:** define the order state machine at least as `draft → pending_payment → paid/processing → fulfilment → completed/cancelled`, with allowed transitions owned by backend.
3. **Before M5:** confirm the payment/wallet/KYC provider implementation model, sandbox credentials, webhook contract, reconciliation owner, refund policy, and user-facing failure copy.
4. **Before M6:** confirm who publishes operational status and location events, their minimum update frequency, and the behavior when tracking is unavailable.
5. **Before M8:** execute end-to-end tests for Business and Individual journeys, including OTP expiry, KYC pending/rejected, price change, insufficient wallet balance, payment pending/failed, duplicate submit, schedule-proposal expiry, and session expiry.

## MVP release checklist

- The app uses the approved production API configuration outside development.
- All resource actions pass the correct server ID, especially `orderId` and `paymentId`.
- The Price Breakdown labels and field names match the approved UI exactly.
- Payment status, wallet balance, invoices, and tracking are refreshed from the backend after state changes.
- No sensitive KYC, payment-proof, or token data is logged or exposed in screenshots/error messages.
- Key flows are verified on the agreed phone sizes and on at least one physical Android and iOS device.
