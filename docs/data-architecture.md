# Antfost Data Architecture

## 1. What exists in the repo today

The current app already has a clean flow:

`Screen -> Bloc -> UseCase -> Repository -> RemoteDataSource / LocalDataSource`

Important point:

- The repo does **not** contain a real database yet.
- Most data sources are still `Mock*RemoteDataSource` and in-memory `Mock*LocalDataSource`.
- So the best way to understand the system is to map the current domain models into a proper production schema.

Core entities currently visible in code:

- `User`, `UserProfile`
- `Project`
- `MixCode`
- `Order`, `NewCashOrderRequest`
- `Payment`
- `Invoice`, `InvoiceDetail`, `InvoiceLineItem`
- `WalletBalance`, `WalletTransaction`
- `KycStatus`, `KycDocument`
- `AppNotification`

## 2. Best-fit database choice

For this project, the best primary database is:

- `PostgreSQL` for server-side transactional data

Why:

- orders, payments, invoices, wallet, and KYC are strongly relational
- payment and wallet flows need ACID-safe updates
- reporting and joins are important
- foreign keys, indexes, transactions, and auditability matter here

For local mobile storage:

- `SharedPreferences` for tiny flags like onboarding/session markers
- `Hive` for lightweight cached objects
- if you want real offline-first relational sync later, prefer `Drift`/`SQLite`

## 3. Recommended high-level modules

### Identity

- companies
- users
- auth_sessions

### Ordering

- projects
- mix_codes
- orders
- order_deliveries

### Billing

- payments
- invoices
- invoice_documents
- invoice_line_items

### Wallet

- wallet_accounts
- wallet_ledger_entries

### Compliance

- kyc_submissions
- kyc_documents

### Engagement

- notifications

## 4. Recommended table structure

## 4.1 `companies`

One business account. Most business data should belong to the company.

```sql
create table companies (
  id uuid primary key,
  legal_name varchar(150) not null,
  display_name varchar(150),
  vat_number varchar(50),
  billing_address text,
  is_kyc_verified boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
```

## 4.2 `users`

One login user under a company.

```sql
create table users (
  id uuid primary key,
  company_id uuid not null references companies(id),
  full_name varchar(120) not null,
  email varchar(150) unique,
  phone varchar(30) unique,
  passcode_hash text,
  avatar_url text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index idx_users_company_id on users(company_id);
```

## 4.3 `auth_sessions`

Stores device/app sessions or refresh tokens.

```sql
create table auth_sessions (
  id uuid primary key,
  user_id uuid not null references users(id) on delete cascade,
  refresh_token_hash text not null,
  device_id varchar(120),
  platform varchar(30),
  expires_at timestamptz not null,
  revoked_at timestamptz,
  created_at timestamptz not null default now()
);

create index idx_auth_sessions_user_id on auth_sessions(user_id);
```

## 4.4 `projects`

Delivery/customer sites saved by the company.

```sql
create table projects (
  id uuid primary key,
  company_id uuid not null references companies(id),
  created_by_user_id uuid references users(id),
  name varchar(150) not null,
  location text not null,
  description text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index idx_projects_company_id on projects(company_id);
```

## 4.5 `mix_codes`

Product master data.

```sql
create table mix_codes (
  id uuid primary key,
  code varchar(50) not null unique,
  mix_type varchar(80) not null,
  grade varchar(50),
  price_per_m3 numeric(12,2) not null,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
```

## 4.6 `orders`

This is the core business table.

```sql
create table orders (
  id uuid primary key,
  order_number varchar(40) not null unique,
  company_id uuid not null references companies(id),
  project_id uuid not null references projects(id),
  mix_code_id uuid not null references mix_codes(id),
  created_by_user_id uuid references users(id),

  order_type varchar(30) not null default 'cash',
  status varchar(30) not null,
  payment_status varchar(30) not null default 'pending',

  scheduled_at timestamptz not null,
  time_slot_label varchar(100),

  quantity_m3 numeric(12,2) not null,
  delivered_m3 numeric(12,2) not null default 0,
  total_trips integer,

  structure_ref varchar(120),
  technician_required boolean not null default false,
  temperature_control boolean not null default false,
  pump_required boolean not null default false,
  cube_mould boolean not null default false,
  num_moulds integer not null default 0,

  price_per_m3 numeric(12,2) not null,
  subtotal_amount numeric(12,2) not null,
  vat_amount numeric(12,2) not null default 0,
  total_amount numeric(12,2) not null,
  currency_code char(3) not null default 'AED',

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index idx_orders_company_id on orders(company_id);
create index idx_orders_project_id on orders(project_id);
create index idx_orders_mix_code_id on orders(mix_code_id);
create index idx_orders_status on orders(status);
create index idx_orders_scheduled_at on orders(scheduled_at);
```

## 4.7 `order_deliveries`

Tracks real trip-level delivery progress. This is better than only keeping `delivered` and `total` on `orders`.

```sql
create table order_deliveries (
  id uuid primary key,
  order_id uuid not null references orders(id) on delete cascade,
  trip_no integer not null,
  delivered_quantity_m3 numeric(12,2) not null,
  delivered_at timestamptz,
  status varchar(30) not null default 'scheduled',
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (order_id, trip_no)
);

create index idx_order_deliveries_order_id on order_deliveries(order_id);
```

## 4.8 `payments`

One payment record for either an order payment or wallet top-up.

```sql
create table payments (
  id uuid primary key,
  company_id uuid not null references companies(id),
  user_id uuid references users(id),
  order_id uuid references orders(id),

  payment_purpose varchar(30) not null,
  method varchar(30) not null,
  provider varchar(50),
  gateway_transaction_id varchar(120),
  status varchar(30) not null,

  amount numeric(12,2) not null,
  currency_code char(3) not null default 'AED',

  initiated_at timestamptz not null default now(),
  verified_at timestamptz,
  raw_gateway_response jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index idx_payments_company_id on payments(company_id);
create index idx_payments_order_id on payments(order_id);
create index idx_payments_status on payments(status);
```

## 4.9 `wallet_accounts`

One wallet per company is the cleanest design for this app.

```sql
create table wallet_accounts (
  id uuid primary key,
  company_id uuid not null unique references companies(id),
  available_balance numeric(14,2) not null default 0,
  reserved_balance numeric(14,2) not null default 0,
  total_balance numeric(14,2) not null default 0,
  updated_at timestamptz not null default now()
);
```

## 4.10 `wallet_ledger_entries`

This is the source of truth for wallet history. Balance should be derived or transactionally maintained from this ledger.

```sql
create table wallet_ledger_entries (
  id uuid primary key,
  wallet_account_id uuid not null references wallet_accounts(id) on delete cascade,
  company_id uuid not null references companies(id),
  order_id uuid references orders(id),
  payment_id uuid references payments(id),

  entry_type varchar(30) not null,
  direction varchar(10) not null,
  status varchar(30) not null,

  amount numeric(14,2) not null,
  title varchar(150) not null,
  subtitle varchar(150),
  entry_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

create index idx_wallet_ledger_wallet_account_id on wallet_ledger_entries(wallet_account_id);
create index idx_wallet_ledger_company_id on wallet_ledger_entries(company_id);
create index idx_wallet_ledger_order_id on wallet_ledger_entries(order_id);
```

## 4.11 `invoices`

Use one core invoice row per billable order.

```sql
create table invoices (
  id uuid primary key,
  invoice_number varchar(40) not null unique,
  company_id uuid not null references companies(id),
  order_id uuid not null unique references orders(id),

  status varchar(30) not null,
  invoice_date date not null,
  due_date date,

  subtotal_amount numeric(12,2) not null,
  vat_amount numeric(12,2) not null default 0,
  total_amount numeric(12,2) not null,
  currency_code char(3) not null default 'AED',

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index idx_invoices_company_id on invoices(company_id);
create index idx_invoices_order_id on invoices(order_id);
```

## 4.12 `invoice_documents`

This table is important because the current app model allows multiple invoice document types like `receipt` and `vat`.

```sql
create table invoice_documents (
  id uuid primary key,
  invoice_id uuid not null references invoices(id) on delete cascade,
  document_type varchar(30) not null,
  status varchar(30) not null,
  file_url text,
  generated_at timestamptz,
  created_at timestamptz not null default now(),
  unique (invoice_id, document_type)
);

create index idx_invoice_documents_invoice_id on invoice_documents(invoice_id);
```

## 4.13 `invoice_line_items`

```sql
create table invoice_line_items (
  id uuid primary key,
  invoice_id uuid not null references invoices(id) on delete cascade,
  description varchar(255) not null,
  quantity numeric(12,2) not null,
  unit_price numeric(12,2) not null,
  line_total numeric(12,2) not null,
  sort_order integer not null default 1
);

create index idx_invoice_line_items_invoice_id on invoice_line_items(invoice_id);
```

## 4.14 `kyc_submissions`

KYC should be versioned by submission, not just a single status field on the user.

```sql
create table kyc_submissions (
  id uuid primary key,
  company_id uuid not null references companies(id),
  submitted_by_user_id uuid references users(id),
  full_name varchar(150) not null,
  emirates_id varchar(80),
  trade_license_number varchar(80),
  status varchar(30) not null,
  submitted_at timestamptz not null default now(),
  reviewed_at timestamptz,
  reviewed_by varchar(120),
  rejection_reason text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index idx_kyc_submissions_company_id on kyc_submissions(company_id);
create index idx_kyc_submissions_status on kyc_submissions(status);
```

## 4.15 `kyc_documents`

```sql
create table kyc_documents (
  id uuid primary key,
  submission_id uuid not null references kyc_submissions(id) on delete cascade,
  document_type varchar(50) not null,
  file_url text not null,
  created_at timestamptz not null default now()
);

create index idx_kyc_documents_submission_id on kyc_documents(submission_id);
```

## 4.16 `notifications`

Attach notifications to users, and optionally to a business entity.

```sql
create table notifications (
  id uuid primary key,
  user_id uuid not null references users(id) on delete cascade,
  notification_type varchar(30) not null,
  title varchar(150) not null,
  message text not null,
  related_entity_type varchar(30),
  related_entity_id uuid,
  is_read boolean not null default false,
  created_at timestamptz not null default now(),
  read_at timestamptz
);

create index idx_notifications_user_id on notifications(user_id);
create index idx_notifications_is_read on notifications(is_read);
create index idx_notifications_created_at on notifications(created_at desc);
```

## 5. Table linking structure

This is the most important relationship map:

```text
companies 1----* users
companies 1----* projects
companies 1----* orders
companies 1----* payments
companies 1----1 wallet_accounts
companies 1----* invoices
companies 1----* kyc_submissions

users 1----* auth_sessions
users 1----* notifications
users 1----* projects(created_by)
users 1----* orders(created_by)
users 1----* payments

mix_codes 1----* orders
projects 1----* orders

orders 1----* order_deliveries
orders 1----* payments
orders 1----1 invoices

invoices 1----* invoice_documents
invoices 1----* invoice_line_items

wallet_accounts 1----* wallet_ledger_entries
payments 1----* wallet_ledger_entries
orders 1----* wallet_ledger_entries

kyc_submissions 1----* kyc_documents
```

## 6. How current app models map to tables

| App model | Best database mapping |
|---|---|
| `User` | `users` + `companies.is_kyc_verified` |
| `UserProfile` | `users` joined with `companies` |
| `Project` | `projects` |
| `MixCode` | `mix_codes` |
| `NewCashOrderRequest` | insert into `orders` |
| `Order` | `orders` joined with `projects` and `mix_codes` |
| `Payment` | `payments` |
| `Invoice` | `invoices` + aggregated `invoice_documents` |
| `InvoiceDetail` | `invoices` + `invoice_documents` + `invoice_line_items` + company billing data |
| `WalletBalance` | `wallet_accounts` |
| `WalletTransaction` | `wallet_ledger_entries` |
| `KycStatus` | latest row from `kyc_submissions` |
| `KycDocument` | `kyc_documents` |
| `AppNotification` | `notifications` |
| `HomeData.activeOrders` | query/view from `orders` where status in active states |

## 7. Recommended read models and views

To keep the mobile app simple and fast, add these backend views or API DTOs:

- `v_active_orders`
  - `orders + projects + mix_codes`
  - used by Home and My Orders

- `v_invoice_list`
  - `invoices + invoice_documents`
  - returns invoice id, order number, total, date, list of document types, invoice status

- `v_wallet_summary`
  - aggregated from `wallet_accounts + wallet_ledger_entries`

This avoids duplicating business data into separate tables just for screens.

## 8. Recommended system flow

## 8.1 App launch flow

```text
Splash
  -> read onboarding flag from local storage
  -> read cached session/user
  -> if no onboarding: Onboarding
  -> if no session: Get Started / Sign In
  -> if logged in but KYC not verified: KYC
  -> else: Home
```

## 8.2 Authentication flow

```text
Sign in / Sign up
  -> AuthBloc
  -> AuthRepository
  -> AuthRemoteDataSource
  -> users + auth_sessions
  -> cache user/session locally
  -> route to next state
```

## 8.3 Order creation flow

```text
Load new order form
  -> fetch mix_codes
  -> fetch projects

Submit new cash order
  -> validate selected mix code, quantity, schedule
  -> insert into orders
  -> optionally create initial order_deliveries rows
  -> return created order
  -> refresh orders/home
```

## 8.4 Payment flow

```text
Choose payment method
  -> initiate payment
  -> create payments row(status = pending/processing)
  -> gateway callback / verification
  -> update payments.status = success/failed

if method = wallet:
  -> add wallet_ledger_entries
  -> reserve amount
  -> on confirmation debit reserved amount
  -> update wallet_accounts balances

update orders.payment_status
```

## 8.5 Invoice flow

```text
After successful payment or billing trigger
  -> create invoices row
  -> create invoice_line_items
  -> create invoice_documents(receipt/vat)
  -> expose list screen and detail screen
  -> download uses invoice_documents.file_url
```

## 8.6 Wallet flow

```text
Add funds
  -> payment gateway
  -> payments row(payment_purpose = wallet_topup)
  -> success
  -> wallet_ledger_entries credit
  -> wallet_accounts balance update
```

## 8.7 KYC flow

```text
Submit KYC
  -> create kyc_submissions row(status = pending)
  -> upload kyc_documents
  -> reviewer approves/rejects
  -> update kyc_submissions.status
  -> sync companies.is_kyc_verified
```

## 8.8 Notification flow

```text
Order created / payment success / KYC update / system event
  -> create notifications row
  -> app fetches notifications
  -> mark read updates is_read + read_at
```

## 9. Best optimization decisions for this project

These are the most useful design choices for this app:

- Keep `company` as the main business owner of orders, invoices, wallet, and KYC.
- Keep `users` as login actors under that company.
- Use one `orders` table instead of separate tables for active/scheduled/completed orders.
- Use `order_deliveries` for trip-level tracking instead of storing only display values.
- Use `wallet_ledger_entries` as the source of truth, not just a mutable balance field.
- Keep `payments` separate from `wallet_ledger_entries`; payment is gateway/business event, ledger is accounting movement.
- Use `invoice_documents` instead of storing invoice types as an array column.
- Use backend views/read DTOs for Home and Invoice List instead of duplicating UI tables.

## 10. Recommended local app cache structure

If you wire local storage later, keep it small and screen-focused:

- `local_session`
  - user id
  - token / refresh token
  - is_logged_in

- `local_app_flags`
  - onboarding_complete

- `cache_profile`
- `cache_home_data`
- `cache_orders`
- `cache_invoices`
- `cache_invoice_details`
- `cache_wallet_summary`
- `cache_wallet_transactions`
- `cache_notifications`
- `cache_kyc_status`

This matches the repository pattern already used in the app.

## 11. Short final summary

If you want the cleanest mental model, think of the project like this:

- `Company` is the root business entity
- `User` operates inside a company
- `Project` is the delivery site
- `MixCode` is the product
- `Order` is the main transaction
- `Payment` settles the order
- `WalletLedger` tracks money movement
- `Invoice` bills the order
- `KYCSubmission` verifies the company
- `Notification` informs the user

That is the most stable and scalable structure for the current Antfost app.
