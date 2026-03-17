# Multiple Ride Requests — Queue-Based Card UI

Transform the current single full-page `RideRequestScreen` into a multi-ride-request queue screen with swipable/scrollable ride request cards — similar to how Rapido, Ola, and Uber show incoming ride requests to drivers.

## Competitor UX Research (Rapido / Ola / Uber)

### How They Show Multiple Ride Requests to Drivers

| Feature | Rapido | Ola | Uber |
|---|---|---|---|
| **Request format** | Full-screen card with timer, pickup/drop pins on mini-map | Bottom sheet card overlaying map | Bottom sheet card overlaying map |
| **Multiple requests** | Queue of cards — new requests stack on top; driver sees one at a time with swipe/auto-rotate | Single card at a time (sequential model) with queue behind | Auto-rotation timer; one card at a time |
| **Timer** | Circular countdown (25s default), prominently placed on accept button | Linear or arc progress bar at the top | Countdown ring around accept button |
| **Key info shown** | Pickup area, Drop area, Distance to pickup, Trip distance, Fare estimate, Vehicle type badge | Pickup address, Drop address, ETA to pickup, Fare, Rating | Pickup area, Ride type, Fare range, Timer |
| **Actions** | Accept (big green), Skip/Decline (smaller) | Accept, Decline | Accept (auto-declines on timeout) |
| **Sound** | Looping alert tone while card is visible | Alert tone + vibration | Alert tone |

### Design Principles We'll Follow

1. **Card-Based Layout** — Each ride request is a compact card showing essential info at a glance
2. **Stacked/Scrollable Queue** — Multiple cards visible, newest on top, scrollable vertically
3. **Per-Card Independent Timer** — Each card has its own countdown timer from backend's `timeout` field
4. **Auto-Remove on Timeout** — Cards auto-remove when their timer expires (auto-decline best-effort)
5. **Accept → Navigate** — Tapping Accept on any card triggers the accept flow and clears the entire queue
6. **Cancel/Decline → Remove Single Card** — Declining removes only that card, others remain
7. **Clean Background** — Show a clean background behind the stacked cards, with no map.

---

## Backend/Event Contract (as per current system)

- **Atomic accept is server-side**: only one driver can accept an order.
- **No `offerId`**: we treat **`orderId` as the unique key** for queue items.
- **Socket events available**:
  - `ride:newRide` (incoming request)
  - `ride:rideAccept` (accept initiated/ack, if present in your system)
  - `ride:rideConfirmed` (final confirmation that accept succeeded; name may differ)
  - `ride:orderCancelled` (rider cancelled before acceptance or during flow)
- **Reconnect + current-order API**:
  - On reconnect, your existing “current order” API is the source of truth for whether the driver is already on an active ride.

Client rule: If `ride:newRide` repeats for the same `orderId` (reconnect/retry), **dedupe** and update the existing queue item instead of adding a duplicate card.

---

## Proposed Architecture

```mermaid
flowchart TD
    A[SocketManager: ride:newRide] -->|Adds to list (dedupe by orderId)| B[RideRequestQueueController]
    A2[SocketManager: ride:orderCancelled] -->|Removes from list| B
    A3[SocketManager: ride:rideConfirmed] -->|Accept success → clear queue| B
    B -->|Observable RxList| C[RideRequestQueueScreen]
    C -->|For each ride| D[RideRequestCard Widget]
    D -->|Accept tapped| E[OrderUpdateController.updateOrder]
    D -->|Decline tapped| F[Decline API + remove card]
    D -->|Timer expired| G[Auto-decline + remove card]
    E -->|Success| H[Navigate to ArrivingClient + clear queue]
```

---

## Proposed Changes

### New Files — State Management

#### [NEW] `lib/controllers/home_controllers/ride_request_queue_controller.dart`

A GetX controller managing the list of pending ride requests:

- **`RxList<RideRequestItem> rideRequests`** — Observable list of all pending ride requests
- **`RideRequestItem`** — Model class wrapping ride data + `Timer` + `RxInt remainingSeconds` + `RxDouble progress`
- **`addRide(Map<String, dynamic> rideData)`** — Adds a new ride to the queue, starts its individual timer
  - If an item with the same `orderId` already exists, **update it** (refresh UI fields / timeout) instead of inserting a duplicate.
- **`removeRide(String orderId)`** — Removes a ride from the queue (decline/timeout/cancel)
- **`clearAll()`** — Clears all rides (after confirmed accept or going offline)
- **`bool get hasRides`** — Whether queue is non-empty
- **Timer logic**: Each `RideRequestItem` has its own `Timer.periodic` that counts down from the backend `timeout` seconds. On expiry, attempt auto-decline (best effort) and remove the card locally.

Registration: `Get.put(RideRequestQueueController())` in `main.dart` or via bindings.

---

### New Files — UI

#### [NEW] `lib/views/ride_screens/ride_request_queue_screen.dart`

A screen showing a clean background with an overlaying list of ride request cards:

- **Layout**: `Stack` with a clean background + `DraggableScrollableSheet` or `ListView` overlay from the bottom
- **Card List**: `Obx(() => ListView.builder)` driven by `RideRequestQueueController.rideRequests`
- **Empty State**: When list is empty, auto-navigate back to `BottomnavmainScreen`
- **Pop Scope**: `canPop: false` while rides are in queue (same as current screen)

#### [NEW] `lib/views/ride_screens/widgets/ride_request_card.dart`

A compact, self-contained card widget for each ride request, inspired by Rapido/Ola:

**Visual Design:**
```
┌─────────────────────────────────────────────┐
│  ₹ 180 (Fare Price)                         │
│─────────────────────────────────────────────│
│  📍 2.3 km (Distance to pickup)             │
│  🟢 Pickup: 56, Apsara Complex, Bhopal...   │
│                                             │
│  📏 6.5 km (Distance to drop)               │
│  🔴 Drop: GVFH+RFR, Agarkar Nagar, Pune...  │
│─────────────────────────────────────────────│
│  [ ✕ ]                   [ ✓ Accept  ⏱ 15s ]│
└─────────────────────────────────────────────┘
```

---

### Modified Files — Socket Manager

#### [MODIFY] `lib/services/apiservices/socket_manager.dart`

**In `ride:newRide` handler:**
- Instead of `Get.to(() => RideRequestScreen(rideData: rideData))`, call `RideRequestQueueController.addRide(rideData)`
- If queue screen is not open, navigate to `RideRequestQueueScreen`
- If already open, just add/update the list (UI auto-updates via `Obx`)

**In `ride:rideConfirmed` handler (or your equivalent “accepted confirmed” socket event):**
- If confirmation indicates success for `orderId`, call `RideRequestQueueController.clearAll()` and navigate to the accepted flow screen (same destination as today).
- If confirmation indicates failure (already assigned/expired), remove only that `orderId` from queue and keep others.

**In `ride:orderCancelled` handler:**
- If cancelled `orderId` exists in the queue, remove it.
- If no rides remain, navigate back to home.
- Existing logic for active ride cancellation remains unchanged.

**In reconnect handling:**
- After reconnect, call your existing “current order” API.
  - If it returns an active/accepted ride, clear queue and continue current flow.
  - If it returns a pending ride request payload (if supported), add/update it in queue (dedupe by `orderId`).

**In `checkPendingRideFromKilledState()`:**
- Instead of navigating to `RideRequestScreen`, add the pending ride to the queue controller and navigate to `RideRequestQueueScreen`.

---

### Modified Files — App Initialization

#### [MODIFY] `lib/main.dart`

- Register `RideRequestQueueController` via `Get.put(RideRequestQueueController())` alongside other controllers during app initialization.

---

## Verification Plan

### Build Verification
- Run `flutter build apk --debug`
- Run `flutter analyze`

### Manual Verification (Requires Backend)

1. **Single ride request arrives** → Queue screen opens with one card showing correct pickup/drop/fare/distance/timer
2. **Timer countdown** → Timer counts down and card auto-removes on 0
3. **Multiple ride requests** → Send 2-3 `ride:newRide` rapidly → verify multiple cards
4. **Accept one ride** → Tap Accept → verify navigation to accepted flow and other cards cleared after confirmation
5. **Decline one ride** → Tap Decline → verify only that card removed
6. **Order cancelled by rider** → `ride:orderCancelled` for queued ride → card removed
7. **All cards removed** → When last card removed, auto-navigate back to home
8. **App killed state** → reopen → pending ride is shown in queue screen
9. **Sound/Notification** → sound plays for new rides
10. **Reconnect duplicate protection** → reconnect + re-send same `ride:newRide` for same `orderId` → verify no duplicate card
11. **Confirmed event clears queue** → with 2 queued rides, accept one, wait for confirmation → queue clears and app navigates to accepted flow

