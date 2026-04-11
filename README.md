# Velo Toulouse

A Flutter-based mobile application focused on **refactoring and enhancing an existing bike rental and subscription system in Toulouse by following MVVM design pattern**.


---

## 📱 Features

### US1 – Select a Pass
Refactored the subscription flow to allow users to browse and select bike rental passes more efficiently.

### US2 – View Stations on a Map
Improved map integration for displaying bike stations with better performance and usability.

### US3 – Pay for Ticket or Pass
Enhanced the payment flow with cleaner state handling and improved user experience.

---

## Tech Stack

- **Flutter (Dart)** – Cross-platform mobile development  
- **Firebase and Firestore** – Backend data handling  

---

## Project Goal

- Improve the existing application by enhancing **UI/UX design and user experience**
- Refine user flows for better usability and smoother interactions
- Enhance and update key features without rebuilding the entire application
- Improve overall consistency and visual clarity across screens

---

## Project Structure

| Path | Role |
|------|------|
| `lib/models/` | Domain entities (subscription, station, bike, booking, …) |
| `lib/data/dtos/` | Firestore ↔ model mapping |
| `lib/data/repositories/` | Repository interfaces + mock and Firebase implementations |
| `lib/ui/screens/` | Feature screens and widgets |
| `lib/ui/screens/**/view_model/` | `ChangeNotifier` view models |
| `lib/ui/states/` | UI state objects (often with `AsyncValue` for async loading) |
| `lib/ui/theme/` | App colors and theming |
| `lib/utils/` | Shared helpers (`async_value`, map bounds, Firestore path constants, …) |
| `assets/` | Images (e.g. static map) |
| `scripts/seed/` | Optional Node script to seed Firestore |

**Architecture (short):** UI → ViewModel (`Provider` / `ChangeNotifierProvider`) → Repository → Firestore or mock. Repositories are provided at app root; view models are scoped per tab or flow (e.g. map vs subscription).

---

## Run / backend

- Entrypoint is typically `lib/main_dev.dart` (see your IDE run config).  
- **Firebase vs mock:** controlled by compile-time `USE_FIREBASE` (see `main_dev.dart` / `main_common.dart`). Configure Firebase (`firebase_options.dart`, platform files) before using Firestore for real data.
