# Overview & Goal

## Why this app exists

This is the digital counterpart of the **paper checklist** that a Tecnam P92
Echo pilot follows on every flight from their base near **Olocau / Bétera**
(Valencia, Spain). The paper form is transcribed block-by-block from the ULR
training organisation dossier for the aircraft with registration **EC-DG4**.

A mobile checklist beats paper in the cockpit for a few concrete reasons:

- **Progress is persisted** — you never lose your place between flights.
- **The take-off gate removes judgement calls** — the app itself refuses to
  authorise take-off until every required item is checked, mirroring the
  organisation's rule *"no despegar hasta que esté checado TODO el
  checklist"* (do not take off until the whole checklist is checked).
- **Live data where it matters** — the altimeter setting (QNH) is pulled from
  the nearest reachable airport's real METAR, so the pilot no longer has to
  remember or fetch it separately.
- **One hand, big targets** — designed to be tapped in the cockpit without
  fumbling.

## The product goals

1. **Fidelity to the source.** The checklist is a faithful transcription of
   the operator's dossier — same block headings, same item text, same
   notes (ON/OFF/CHK, 15°, etc.). The app should never invent or reorder
   checklist content.

2. **Enforce safety as a hard gate.** The single most important product rule:
   take-off is impossible until blocks 1–7 are fully checked. This is not a
   suggestion — it is a hard UI lock.

3. **Zero-friction in the cockpit.** Large taps, per-block scrolling, no
   hidden content, visible progress. The pilot should spend seconds, not
   minutes, interacting.

4. **Honest data.** The live METAR altimeter is *fail-closed*: if there is no
   real value, nothing is shown. The app never fabricates a pressure reading.

## The two-phase flight model

The app splits a flight into two phases, matching how a real sortie runs:

| Phase | Behaviour |
|-------|-----------|
| **Pre-take-off** (blocks 1–7) | The gate shows a locked **DESPEGAR** until every item in blocks 1–7 is checked. Completing them unlocks a green **DESPEGAR**. |
| **Landing** (blocks 8–9) | Confirming take-off jumps the pilot to block 8 (**EN FINAL**) and the gate switches to **ATERRIZADO**; it unlocks once *all* items (including EN FINAL and PARADA DE MOTOR) are done. |

## Target user

A single-pilot, GA/ULM operator (the project owner) flying the P92 Echo from
a private field. The app is built around their workflow and their design
preference (cream background, green accent — see [UI & theming](ui.md)).
