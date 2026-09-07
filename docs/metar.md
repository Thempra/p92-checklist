# Live METAR / Altimeter (QNH)

The ALTÍMETRO checklist item shows the current **QNH** (altimeter setting)
for the pilot, pulled from the **real, live METAR** of the nearest reachable
airport. This removes the need to look up the pressure separately before
setting the altimeter.

## Data source

The app uses the **public VATSIM METAR** endpoint, which requires no API key:

```
https://metar.vatsim.net/metar.php?id=<ICAO>
```

It returns the raw, single-line METAR for the given ICAO code, e.g.:

```
LEBT 062200Z AUTO VRB02KT CAVOK 24/07 Q1021
LEVC 062200Z 32005KT CAVOK 27/14 Q1021 NOSIG
```

## How the QNH is parsed

The service reads the raw METAR and looks for the **Q group** with a regular
expression `\bQ(\d{3,4})\b`:

| Group | Meaning          | Example    |
|-------|------------------|------------|
| `Q1021` | QNH in **hPa** | `Q1021` → `1021 hPa` |

The captured digits are parsed as the pressure in hectopascals and shown as
`LEBT 1021 hPa`.

## Airport selection (nearest first)

The aircraft is based near **Olocau / Bétera** (Valencia, Spain), so the
candidate airports are those nearby, ordered by approximate distance:

| ICAO | Name      | Approx. distance |
|------|-----------|------------------|
| LEBT | Bétera    | 2 km             |
| LEVC | Valencia  | 25 km            |
| LEAL | Alicante  | 135 km           |

The service tries them **in that order**, returning the first one that yields
a valid METAR with a Q group. This is a **fixed list**, not GPS-derived —
deliberately, because the aircraft always operates from the same base and GPS
would add an unnecessary permission for no benefit.

## Fail-closed behaviour (important)

- If the **nearest** airport returns an invalid/empty METAR, the service
  moves on to the next.
- If **no** airport can be reached (offline, timeout, all invalid), the
  result is marked `fromLive: false` and **no QNH value is displayed** in the
  ALTÍMETRO item. The app never fabricates a pressure reading.

> This is a strict *fail-closed* policy: without a real live value, the pilot
> sees nothing rather than a possibly-wrong number.

## `AltimeterResult`

`MetarService.fetchNearbyAltimeter()` returns an `AltimeterResult`:

| Field      | Type     | Meaning                                              |
|------------|----------|------------------------------------------------------|
| `icao`     | `String` | ICAO of the airport used (e.g. `LEBT`).              |
| `name`     | `String` | Human name (e.g. `Bétera`).                          |
| `qnh`      | `int`    | Pressure in hPa.                                     |
| `metar`    | `String?`| Raw METAR string, or null when offline.              |
| `fromLive` | `bool`   | `true` = real fetch; `false` = no live data.         |
| `display`  | `String` | Rendered `"LEBT 1021 hPa"`.                          |

## Network plumbing

- `MetarService` injects an `http.Client` (so tests can pass a `MockClient`).
- `MetarNotifier` wraps the service, fetches **once** on startup
  (idempotent `ensureLoaded()`), and notifies listeners when the result
  arrives.
- **Android permission:** the release `AndroidManifest.xml` declares
  `android.permission.INTERNET`. (Without it, release builds would silently
  fail all network calls — this was a real bug that was fixed.)
- Request timeout is ~8s; failures fall through to the fail-closed path.
