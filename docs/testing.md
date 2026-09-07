# Testing

The project uses `flutter_test` with a **GTD-style coverage** of the parts
that matter most: data integrity, the take-off/landing gate logic, and the
live-METAR parsing. There are currently **20 tests** across 3 suites.

## Test suites

### `test/checklist_data_test.dart` — data integrity

Guards the source-of-truth file so a careless edit can never silently break
the checklist:

- **Every item `id` is unique** — required because ids are the persistence
  and state keys.
- **There are exactly 9 blocks, in the pilot order.**
- **Block 2 groups the wing and tail checks** (the renamed
  "REVISIÓN EXT. · PLANOS Y COLA" block).
- The flattened checkable-item count is consistent (`kTotalCheckableItems`).

### `test/checklist_store_test.dart` — gate & state logic

Covers the heart of the safety rule:

- toggling items on/off reflects in `isChecked`,
- **take-off stays locked** until blocks 1–7 are complete
  (`preTakeoffComplete`),
- **landing unlocks** only when the whole checklist (incl. blocks 8–9) is
  complete,
- `reset()` clears everything.

### `test/metar_service_test.dart` — live METAR parsing

Uses `package:http/testing`'s `MockClient` so no network is needed:

- **parses QNH from a live METAR** and picks the nearest airport first,
- **falls back fail-closed when every airport is unreachable** (returns
  `fromLive: false`, no fabricated value),
- **skips an airport whose METAR has no Q group** and reaches the next one.

### `test/screenshot_test.dart` — golden-image README screenshot

Renders a realistic portrait copy of the main screen (pre-seeded with checked
items) and produces `test/screenshots/checklist_main.png`, the image used in
the README. Regenerate it with:

```bash
flutter test --update-goldens test/screenshot_test.dart
```

## Running the suite

```bash
flutter test            # run everything
flutter analyze         # static analysis (no issues expected)
```

A quick sanity note: `flutter test` prints a warning that the MetarService
creates an `HttpClient`; mock-based tests handle this correctly, and the
golden screenshot test intentionally exercises the widget tree with a default
(no-op) notifier.

## Golden-screen screenshot

The golden image is committed to the repo at
`test/screenshots/checklist_main.png` and referenced by `README.md`. It is
generated at 3× device-pixel ratio from a 360×740 logical surface so it reads
cleanly on Retina-class screens.
