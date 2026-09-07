# Flight data model

The entire checklist is defined in a single file,
`lib/data/checklist_data.dart`. It is the **source of truth**: all screens,
widgets and tests read from it, and the UI renders generically from the model
rather than hard-coding item lists.

## Models

### `ChecklistItem`

A single line of the checklist.

| Field       | Type     | Meaning                                                        |
|-------------|----------|----------------------------------------------------------------|
| `id`        | `String` | Stable, unique identifier (e.g. `pem_altimetro`). Used for state/persistence. |
| `label`     | `String` | The action text shown to the pilot (e.g. `ALTÍMETRO`).        |
| `note`      | `String?`| An optional trailing hint (e.g. `ON`, `OFF`, `CHK`, `15°`, `2.500`). |
| `isHeader`  | `bool`   | When true, renders as a non-tappable section header (e.g. `PRUEBA DE MOTOR`). |

### `ChecklistGroup`

One flight block / screen.

| Field        | Type     | Meaning                                                         |
|--------------|----------|-----------------------------------------------------------------|
| `title`      | `String` | Full block heading (e.g. `REVISIÓN EXTERIOR`).                 |
| `shortTitle` | `String` | Short name for the step indicator (e.g. `Exterior`).           |
| `step`       | `int`    | 1-based block number.                                           |
| `items`      | `List<ChecklistItem>` | The items in this block.                          |

`ChecklistGroup.checkableCount` returns the number of items **minus**
`isHeader` items — that is, the number of things the pilot can actually check.

## The 9 blocks

The dossier is organised into 9 blocks, in flight order. Block numbering and
take-off gating: **blocks 1–7 are pre-take-off**, **blocks 8–9 are the
landing/shutdown phase** (`kTakeoffLastBlockIndex = 6`, i.e. block 7).

| # | Title (UI)                        | shortTitle   | Phase        |
|---|-----------------------------------|--------------|--------------|
| 1 | REVISIÓN EXTERIOR                 | Exterior     | Pre-take-off |
| 2 | REVISIÓN EXT. · PLANOS Y COLA     | Planos       | Pre-take-off |
| 3 | PUESTA EN MARCHA                  | Arranque     | Pre-take-off |
| 4 | DESPUÉS DE ARRANCAR               | Post-arranque| Pre-take-off |
| 5 | RODAJE · PRUEBA DE MOTOR          | Rodaje       | Pre-take-off |
| 6 | ANTES DE DESPEGAR                 | Pre-despegue | Pre-take-off |
| 7 | BRIEFING                          | Briefing     | Pre-take-off |
| 8 | EN FINAL                          | Final        | Landing     |
| 9 | PARADA DE MOTOR                   | Parada       | Landing     |

## Special items

Two items carry extra behaviour beyond a plain checkbox:

- **`ALTÍMETRO`** (`pem_altimetro`) — its note is replaced by the **live QNH**
  of the nearest reachable airport, rendered as e.g. `LEBT 1021 hPa`. If no
  live data is available the note is suppressed entirely (fail-closed).
  See [Live METAR / altimeter](metar.md).

- **`RADIO`** (`pem_radio`) — carries the VHF frequencies as its note:
  `OLOCAU 130,125 · BÉTERA 126,750 · VALENCIA 120,100`.

## Global helpers

| Helper                 | Returns                                              |
|------------------------|------------------------------------------------------|
| `kAllCheckableItems()` | Flattened `List<ChecklistItem>` of every tappable item across all blocks. |
| `kTotalCheckableItems` | `kAllCheckableItems().length` (currently 84).        |
| `kTakeoffLastBlockIndex` | `6` — index of block 7 (BRIEFING), the last pre-take-off block. |

## Integrity guarantees (enforced by tests)

- Every item `id` is unique across the whole checklist.
- There are exactly 9 blocks, in the expected pilot order.
- Block 2 groups the wing (plano) and tail checks together.
- `kTotalCheckableItems` is consistent with the flattened list.

These rules are codified in `test/checklist_data_test.dart` so that adding an
item can never silently break gating or state persistence.
