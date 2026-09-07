# Architecture

The app follows a simple, testable **layered architecture**. There is no
third-party state-management framework; the design leans on Flutter's
built-in `ChangeNotifier` pattern kept deliberately small.

## Layer overview

```
┌─────────────────────────────────────────────────────────────┐
│  Screens (UI)                                               │
│  lib/screens/checklist_screen.dart                          │
│    └─ orchestrates widgets, owns store + metar notifier     │
├─────────────────────────────────────────────────────────────┤
│  Widgets (presentation)                                     │
│  lib/widgets/*  step_indicator, block_view, item_row,       │
│                  progress_bar, takeoff_gate                 │
├─────────────────────────────────────────────────────────────┤
│  State (application state)                                  │
│  lib/state/checklist_store.dart     checked set + gate      │
│  lib/state/metar_notifier.dart      live QNH               │
├─────────────────────────────────────────────────────────────┤
│  Services (external I/O)                                    │
│  lib/services/metar_service.dart    HTTP → VATSIM METAR     │
├─────────────────────────────────────────────────────────────┤
│  Models + Data (domain)                                     │
│  lib/models/*   checklist_item, checklist_group             │
│  lib/data/checklist_data.dart       source of truth         │
│  lib/theme/app_theme.dart           design tokens           │
└─────────────────────────────────────────────────────────────┘
```

Data always flows **one way**: data → models → state → widgets → screen.
Screens never mutate the data file; they mutate *state* and let
`ListenableBuilder` rebuild the UI.

## File-by-file responsibilities

### Data & domain

- **`lib/data/checklist_data.dart`** — the single source of truth. Defines
  the ordered list of 9 `ChecklistGroup`s, each containing its `ChecklistItem`s,
  plus two public helpers:
  - `kAllCheckableItems()` → flattened list of every tappable item,
  - `kTotalCheckableItems` → its length,
  - `kTakeoffLastBlockIndex` (value `6`) → 0-based index of block 7
    (ASCENSO), i.e. the last pre-take-off block.

- **`lib/models/checklist_item.dart`** — a single checklist line: `id`,
  `label`, optional `note`, and an `isHeader` flag for section headers that
  are not tappable.

- **`lib/models/checklist_group.dart`** — one flight block: `title`,
  `shortTitle`, `step` number, and its `items`. Also computes `checkableCount`
  (items minus headers).

### State

- **`lib/state/checklist_store.dart`** — extends `ChangeNotifier`. Holds a
  `Map<String, bool>` of checked item ids, persists it via
  `shared_preferences`, and implements the take-off/landing gating logic
  (`preTakeoffComplete`, `isComplete`, `hasTakenOff`, `setChecked`, `reset`).

- **`lib/state/metar_notifier.dart`** — extends `ChangeNotifier`. Wraps
  `MetarService`, fetches once (idempotent `ensureLoaded()`), and exposes
  `result` / `isLoading` so the ALTÍMETRO item can re-render when the QNH
  arrives.

### Services

- **`lib/services/metar_service.dart`** — performs the HTTP request to the
  VATSIM METAR endpoint and parses the QNH group. Returns an
  `AltimeterResult` (icao, name, qnh, raw metar, `fromLive`). Falls back over
  the ordered airport list and, as a last resort, a hard-coded default —
  see [Live METAR / altimeter](metar.md).

### Theme

- **`lib/theme/app_theme.dart`** — `AppColors` constants and `buildAppTheme()`
  producing a `ThemeData` with the cream background and green accent. See
  [UI & theming](ui.md).

### Widgets & screens

- **`lib/screens/checklist_screen.dart`** — the only screen. Owns the
  `ChecklistStore`, `MetarNotifier` and a `PageController`. Renders the
  `AppBar`, the `StepIndicator`, a cached `PageView` of `BlockView`s, and the
  `TakeoffGate`. Handles block navigation and the reset dialog.
- **`lib/widgets/step_indicator.dart`** — horizontal pager of the 9 steps;
  highlights the current block and marks completed ones with a green check.
- **`lib/widgets/block_view.dart`** — one block: header (number + title), a
  per-block progress line, and all items in a scrollable card. No prev/next
  buttons.
- **`lib/widgets/item_row.dart`** — one tappable item. For the ALTÍMETRO item
  it additionally renders the live QNH from the `MetarNotifier`.
- **`lib/widgets/progress_bar.dart`** — percent progress decoration.
- **`lib/widgets/takeoff_gate.dart`** — the pinned bottom gate (see below).

## State management & data flow

`ChecklistStore` is a plain `ChangeNotifier`; the screen wraps its subtree in
`ListenableBuilder(listenable: _store, …)`. Any `setChecked` / `reset` /
take-off mutation triggers a rebuild of exactly the parts that read store
state. `MetarNotifier` is observed by `ItemRow` for the live altimeter.

**Persistence flow:** `ChecklistStore.load()` reads the saved checked-ids set
from `shared_preferences` at startup; every `setChecked` persists immediately
(no debounce — items are few and writes are cheap).

## The take-off gate

The core safety mechanism lives in the store and is visualised by
`TakeoffGate`:

- `preTakeoffComplete` is true only when the count of checked items in blocks
  `0..kTakeoffLastBlockIndex` (1–7) equals the total checkable count of those
  blocks.
- `hasTakenOff` flips true when the pilot confirms the DESPEGAR dialog; the
  screen then jumps to block 8 and the gate re-renders as the landing-phase
  "ATERRIZADO" gate, which unlocks via `isComplete` (all blocks, including
  8–9).

## Why this design

- **No state library** keeps the dependency surface minimal and the logic
  trivially testable (the store is pure Dart + one small persistence call).
- **Source of truth in data + thin models** means adding a checklist item is
  a one-line change in one file, and data-integrity tests guard it.
- **Notifier-bound live data** (`MetarNotifier`) keeps network concerns out
  of the widget tree and makes the METAR logic unit-testable with a mocked
  HTTP client.
