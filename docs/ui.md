# UI & Theming

The user experience is designed for **one-handed use in the cockpit** on a
phone, with a warm, readable palette.

## Design system

The visual identity lives in `lib/theme/app_theme.dart`. It reflects the
owner's preference: a **cream background with a green accent** (no cold blue,
no garish purple).

### Palette (`AppColors`)

| Token         | Hex       | Use                                      |
|---------------|-----------|------------------------------------------|
| `background`  | `#F5F2EE` | Cream page background.                   |
| `surface`     | `#FFFFFF` | Cards / item rows.                       |
| `accent`      | `#0C8A6D` | Green — primary actions, checked state.  |
| `accentDark`  | `#086B54` | Hover/pressed green.                     |
| `textPrimary` | `#1F2A24` | Main text (near-black green).            |
| `textMuted`   | `#6B7A72` | Secondary/muted text.                    |
| `danger`      | `#C63B3B` | Destructive (reset).                     |
| `warning`     | `#C98A1B` | Amber — pending / in-progress signals.   |
| `headerBar`   | `#1F2A24` | App bar & gate background (dark).        |

### Theme (`buildAppTheme()`)

`Material 3` is enabled; the seed colour is the green accent. The theme sets
a cream `scaffoldBackgroundColor`, cards with soft `14px` rounded corners and
zero elevation, a dark `AppBar`, and green elevated buttons.

## Screens & widgets

### `ChecklistScreen` (the only screen)

A `Scaffold` with:

- a dark `AppBar` titled **CHECKLIST** with a reset (`refresh`) action,
- a `StepIndicator`,
- an `Expanded` cached `PageView` of the 9 `BlockView`s,
- a `TakeoffGate` pinned at the bottom.

The screen owns the `ChecklistStore`, the `MetarNotifier`, and the
`PageController`; it also shows the reset confirmation dialog.

### `StepIndicator`

A horizontal strip of the 9 blocks. The **current** block is highlighted; each
**completed** block shows a green check. Tapping a step jumps to that block.

### `BlockView`

One flight block rendered as:

- a header with the block number and title,
- a thin per-block progress line,
- the block's items in a scrollable card.

There are **no prev/next buttons** — navigation is by horizontal page swipe
(kicking in via the `PageView`), which frees vertical space so every item
stays reachable by scrolling.

### `ItemRow`

A single tappable checklist line:

- toggles checked/unchecked on tap,
- shows the item label and its trailing note,
- headers (`isHeader: true`) render as non-interactive section dividers,
- the `ALTÍMETRO` row renders the live QNH (`LEBT 1021 hPa`) instead of a
  static note, and only when a live value exists (fail-closed).

### `TakeoffGate`

The bottom-pinned safety gate, dual-phase:

- **Pre-take-off:** a locked **DESPEGAR** button that shows how many items
  remain. When blocks 1–7 are complete it unlocks into a green **DESPEGAR**.
- **Landing:** switches to **ATERRIZADO**; unlocks once the whole checklist
  (blocks 1–9) is complete.

It also offers a help button opening the **PARÁMETROS DE MOTOR** reference
modal and a jump-to-first-pending-block shortcut.

### `ProgressBar`

Visual percent progress for a block or the overall flight.
