# US2 — Subscription & pass purchase (Velo Toulouse)

**Report date: 6 April 2026**

This document describes the **UX / product flow** for User Story 2 (subscription and purchasing a plan) and the **implementation architecture** in the Flutter app as of that date: MVVM, state, repositories, DTOs, and dependency injection (`provider`).

---

## 1. Product context

- **Goal:** Let users buy a **pass** (day, monthly, or annual) so they can use bikes repeatedly within a validity window, instead of paying per ride.
- **Rules (business):**
  - Pass types: **Day**, **Monthly**, **Annual** (catalog in Firestore `subscriptions`).
  - Each pass has a **start** and **expiry** (stored on `user_subscriptions`).
  - Only **one active pass per user** at a time; passes are **not** stacked (buying a new one replaces / deactivates the previous active row in Firestore).

---

## 2. UX: Flow B — “Purchasing a plan” (mockup alignment)

### 2.1 Entry

- User taps **Subscription** → lands on the subscription area managed by `SubscriptionFlowScreen`.

### 2.2 Branch: already subscribed vs purchase flow

Before showing the two-step purchase flow, the app loads:

- The **plan catalog** (`subscriptions` collection).
- The user’s **active pass** (`user_subscriptions` where `is_active == true`), if any.

**If** the user already has a **valid** active pass (`is_active` and `expires_at` in the future), the UI shows **`ActiveSubscriptionView`** — a read-only summary (“current subscription”, plan name, renewal/expiry copy). **Flow B (choose plan → pay)** is **not** shown.

**Else** the user enters **Flow B**:

### 2.3 Step 1 — Choose a plan (`SubscriptionsScreen`)

- **Header:** back (to Map tab), title **“Choose a Plan”**, step **“1 of 2”**.
- **Progress:** two segments; first segment highlighted (orange).
- **Content:** list of **plan cards** (Day / Monthly / Annual) with price and marketing lines from `SubscriptionCopy` (UI helper text, not necessarily from Firestore).
- **Default selection:** the ViewModel defaults to **`monthly`** when present (matches “Monthly Pass pre-selected” in the spec).
- **Primary action:** **Continue** → navigates locally to step 2 (still inside the same tab).

### 2.4 Step 2 — Payment (`PaymentScreen`)

- **Header:** back to step 1, title **“Payment”**, **“2 of 2”**.
- **Progress:** both segments filled.
- **Summary:** receipt-style card (`ReceiptCard`) with plan name, **Starts / Expires / Renews** strings from `planDuration(subscription)` (dates derived from `Subscription.durationKind` for display), plus line items and total.
- **Primary action:** **Pay** → calls `UserSubscriptionRepository.recordSubscriptionPurchase`, then **`SubscriptionViewModel.load()`** to refresh, closes the payment step, shows a success snackbar.

This matches the spirit of the mockup: select plan → review dates and totals → confirm payment.

---

## 3. Architecture overview

The app uses **Clean-style layering** with **MVVM** in the UI:

| Layer | Responsibility |
|--------|----------------|
| **Domain models** (`lib/models/`) | Immutable entities: `Subscription`, `UserSubscription`. No Firestore types. |
| **DTOs** (`lib/data/dtos/`) | Parse / serialize Firestore field names (`price_euros`, `duration_kind`, …) into models. |
| **Repositories** (`lib/data/repositories/`) | Abstract APIs + Firebase / Mock implementations; single place for queries and writes. |
| **State** (`lib/ui/states/`) | Immutable snapshots exposed by ViewModels (e.g. `SubscriptionState`). |
| **ViewModels** (`lib/ui/screens/.../view_model/`) | `ChangeNotifier`: async calls, `notifyListeners()`. |
| **Views** (`lib/ui/screens/...`) | Mostly stateless widgets; **watch** ViewModels or receive callbacks. |

Async UI uses **`AsyncValue<T>`** (`lib/ui/utils/async_value.dart`): `loading` | `success` | `error` with optional `data` / `error`.

---

## 4. Data layer

### 4.1 Firestore collections (aligned with `lib/scripts/seed/index.js`)

- **`subscriptions`** — catalog: `name`, `price_euros`, `duration_kind` (`day` / `month` / `year`), `is_active`, `sort_order`. Document id = plan id (`day`, `monthly`, `annual`).
- **`user_subscriptions`** — user entitlement: `user_id`, `subscription_id`, `starts_at`, `expires_at`, `is_active`, `created_at`.

### 4.2 DTOs

- **`SubscriptionDto`** (`data/dtos/subscription_dto.dart`): `fromFirestore(DocumentSnapshot)` → domain **`Subscription`**. Maps `duration_kind` strings to **`SubscriptionType`** via `SubscriptionTypeX.fromDurationKind`.
- **`UserSubscriptionDto`** (`data/dtos/user_subscription_dto.dart`): `fromFirestore(docId, Map)` → domain **`UserSubscription`**. Uses Firestore **`Timestamp`** fields.

### 4.3 Repositories (split by concern)

1. **`SubscriptionRepository`** (`data/repositories/subscription/`)
   - **Only** reads the catalog: `fetchSubscriptions()`.
   - **Firebase:** `SubscriptionRepositoryFirebase` — `orderBy(sort_order)`, filter `is_active`.
   - **Mock:** `SubscriptionRepositoryMock` — fixed in-memory list (seed-like).

2. **`UserSubscriptionRepository`** (`data/repositories/user_subscription/`)
   - **`fetchActiveUserSubscription(userId)`** — query `user_subscriptions` with `user_id` + `is_active == true`, limit 1.
   - **`recordSubscriptionPurchase({ userId, subscriptionId })`** — loads plan for duration, deactivates old active docs, writes a new `user_subscriptions` row with computed `expires_at`.
   - **Firebase:** `UserSubscriptionRepositoryFirebase`.
   - **Mock:** `UserSubscriptionRepositoryMock` — in-memory override + optional `simulateActiveSubscription`; **`recordSubscriptionPurchase`** uses **`SubscriptionRepository.fetchSubscriptions()`** to resolve the chosen plan’s duration (no duplicated catalog).

3. **`BookingRepository`** (out of scope for Flow B UX, but present in app) — latest booking + labels for the Map tab.

**Domain models** live under `lib/models/subscription/` and `lib/models/user_subscription/` — framework-agnostic.

---

## 5. UI layer — subscription MVVM

### 5.1 `SubscriptionState` (`lib/ui/states/subscription_state.dart`)

Holds two independent async channels plus UI selection:

| Field | Type | Meaning |
|--------|------|--------|
| `catalog` | `AsyncValue<List<Subscription>>` | Plan list from `SubscriptionRepository`. |
| `activeSubscription` | `AsyncValue<UserSubscription?>` | Active pass or null. |
| `selected` | `Subscription?` | Card selected on step 1 (default monthly when possible). |

**Derived flags:**

- `isLoading` — either async channel is loading.
- `hasError` — either channel is error.
- `hasActivePass` — both success, `activeSubscription.data` non-null, `isActive`, and **`expiresAt.isAfter(DateTime.now())`**.

### 5.2 `SubscriptionViewModel` (`lib/ui/screens/subscription/view_model/subscription_view_model.dart`)

- Extends **`ChangeNotifier`**.
- **Dependencies (constructor):** `SubscriptionRepository`, `UserSubscriptionRepository`, `userId` (baked-in `'1'` for demo).
- **`load()`:** sets loading on both channels, then `fetchSubscriptions()` + `fetchActiveUserSubscription(userId)`, merges into `SubscriptionState`, picks default selection (`monthly` preferred).
- **`select(Subscription)`:** updates `selected` only.

The ViewModel does **not** talk to widgets directly; it updates `_state` and calls **`notifyListeners()`**.

### 5.3 Views

- **`SubscriptionFlowScreen`** — provides **`ChangeNotifierProvider<SubscriptionViewModel>`** (created once per tab subtree), injects repos via **`context.read<SubscriptionRepository>()`** and **`context.read<UserSubscriptionRepository>()`**, calls **`..load()`** on create.
- **`_SubscriptionFlowInner`** — **StatefulWidget** for local step flag `_onPayment` (plan vs payment).
  - Uses **`context.watch<SubscriptionViewModel>()`** so the subtree rebuilds when the ViewModel notifies.
  - Renders: loading → error+retry → **`ActiveSubscriptionView`** if `hasActivePass` → else **`AnimatedSwitcher`** between **`SubscriptionsScreen`** and **`PaymentScreen`**.
- **`SubscriptionsScreen`** — **watch**es `SubscriptionViewModel`, reads `state`, passes catalog `AsyncValue` into list body; calls `vm.select` on tap; **Continue** calls parent callback (no repository here).
- **`PaymentScreen`** — **stateless**; receives `Subscription` + `onBack` + optional **`onPaymentSuccess`** (async). No ViewModel inside; parent passes closure that **`read`s `UserSubscriptionRepository`**, **`recordSubscriptionPurchase`**, then **`read`s `SubscriptionViewModel`** and **`load()`**.

---

## 6. Dependency injection & providers

### 6.1 App root (`lib/main.dart`)

- **`MultiProvider`** registers **singleton** repository instances:
  - `Provider<SubscriptionRepository>`
  - `Provider<UserSubscriptionRepository>`
  - `Provider<BookingRepository>`
- Built **after** optional **`Firebase.initializeApp()`** when `USE_FIREBASE=true` (`dart-define`).
- Mock **`UserSubscriptionRepositoryMock`** receives the same **`SubscriptionRepository`** instance used for the catalog (for purchase duration resolution).

### 6.2 Where `ChangeNotifierProvider` is used

| Location | Provider | Notes |
|----------|-----------|--------|
| `HomeShell` — Map tab | `ChangeNotifierProvider<BookingViewModel>(create: … ..load())` | `read<BookingRepository>()` in `create`. |
| `SubscriptionFlowScreen` | `ChangeNotifierProvider<SubscriptionViewModel>(create: … ..load())` | `read` both subscription repos in `create`. |

### 6.3 `context.read` vs `context.watch`

- **`watch`** — `SubscriptionFlowScreen` inner widget, `SubscriptionsScreen`: rebuild when `SubscriptionViewModel` changes (catalog, active pass, selection).
- **`read`** — one-off or in callbacks: repository in `create`, **`UserSubscriptionRepository`** in **`onPaymentSuccess`**, **`SubscriptionViewModel`** for **`load()`** after pay (no rebuild subscription to the VM reference itself).

---

## 7. End-to-end MVVM flow (Flow B)

1. **Providers** supply repositories at app root.
2. **`SubscriptionFlowScreen`** creates **`SubscriptionViewModel`** with both repos and runs **`load()`**.
3. **ViewModel** fills **`SubscriptionState`** from **DTOs → models** inside repositories.
4. **View** branches on **`hasActivePass`** vs purchase flow.
5. User selects plan → **`select()`** updates state.
6. User taps Continue → local state opens **`PaymentScreen`**.
7. User taps Pay → **`UserSubscriptionRepository.recordSubscriptionPurchase`** → **`SubscriptionViewModel.load()`** → UI shows **`ActiveSubscriptionView`** if the new pass is active and not expired.

---

## 8. Files — quick map (subscription US2)

| Area | Paths |
|------|--------|
| Models | `lib/models/subscription/subscription.dart`, `lib/models/user_subscription/user_subscription.dart` |
| DTOs | `lib/data/dtos/subscription_dto.dart`, `lib/data/dtos/user_subscription_dto.dart` |
| Repos | `lib/data/repositories/subscription/*`, `lib/data/repositories/user_subscription/*` |
| State | `lib/ui/states/subscription_state.dart` |
| VM | `lib/ui/screens/subscription/view_model/subscription_view_model.dart` |
| Flow UI | `lib/ui/screens/subscription/subscription_screen.dart`, `subscriptions_selection_screen.dart`, `payment_screen.dart` |
| Widgets | `widgets/subscription_selection/*`, `widgets/payment/*`, `widgets/step_progress.dart` |
| Async helper | `lib/ui/utils/async_value.dart` |
| Dates (payment copy) | `lib/ui/utils/plan_duration.dart` |

---

## 9. Notes for reviewers / testers (6 Apr 2026)

- **User id** is fixed to **`"1"`** in ViewModels (no auth).
- **Firestore indexes** may be required for composite queries (e.g. `user_subscriptions` by `user_id` + `is_active`; `bookings` by `user_id` + `reserved_at` on the Map feature).
- Run with **mock** repos by default; use **`--dart-define=USE_FIREBASE=true`** for real Firestore (with platform Firebase config).

This report reflects the codebase structure and behaviour above; adjust if you add auth, navigation 2.0, or Riverpod later.
