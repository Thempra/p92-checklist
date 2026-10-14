# Plan de implementación (p92-checklist)

Secuencia exacta de construcción ordenada por dependencias. Cada paso tiene
criterio de aceptación verificable. Estado: **v1 completada e instalada** —
este plan queda como registro y como playbook para v2/otros checklists.

## Fase 0 — Fundaciones (este repo: `docs/foundation/`)
- [x] S0.1 Escribir PRD, TRD, flow, design brief, backend schema, plan.
      ✔ Aceptación: 6 docs subidos al repo con sign-off del PRD+TRD.

## Fase 1 — Esqueleto y modelo de datos
- [x] S1.1 `flutter create` (Android-only), limpiar template, `analysis_options.yaml`.
      ✔ `flutter analyze` sin errores; `flutter test` verde con 0 tests.
- [x] S1.2 Modelos `ChecklistItem` / `ChecklistGroup` (inmutables).
      ✔ Compilan; `checkableCount` derivado, no duplicado.
- [x] S1.3 Transcribir el dossier a `checklist_data.dart`: 9 bloques, ~92 items,
      ids estables `bloque_item`, notas ON/OFF/CHK.
      ✔ Test: ids únicos, 9 bloques en orden de piloto, conteo chequeables. **Fidelidad
      1:1 con el dossier; nada inventado ni reordenado.**

## Fase 2 — Estado y persistencia
- [x] S2.1 `ChecklistStore extends ChangeNotifier`: toggle/progress/pending.
      ✔ Unit tests de toggle e isChecked.
- [x] S2.2 Lógica de puerta: `preTakeoffComplete` (bloques 1–7), `isComplete`,
      `authorizeTakeoff()`, fase ATERRIZADO.
      ✔ Tests: despegue bloqueado mientras falte 1 item de 1–7; ATERRIZADO solo
      con todo completo; reset limpia todo.
- [x] S2.3 Persistencia SharedPreferences (`checked_ids`, `took_off`) + `load()`
      tolerante a fallos.
      ✔ Test/ manual: matar app a mitad → reaperturar restaura ids y fase.

## Fase 3 — UI
- [x] S3.1 Theme tokens (`AppColors`, Material 3, seed verde, crema, radios 14).
      ✔ Coincide con `design-brief.md`.
- [x] S3.2 `ItemRow` (partida / header / marcado) con hit-area ≥ 48 dp.
      ✔ Marcado communicates check + atenuado (no solo color).
- [x] S3.3 `BlockView` + `PageView` 1 página/bloque + `StepIndicator` + `ProgressBar`.
      ✔ Swipe funciona; cero prev/next buttons; bloque actual resaltado.
- [x] S3.4 `TakeoffGate` fijo abajo: bloqueado+contador / DESPEGAR / ATERRIZADO.
      ✔ El botón imposible de pulsar en disabled; contador exacto.
- [x] S3.5 Reset con diálogo + modal parámetros motor + saltar-al-primer-pendiente.
      ✔ Reset pide confirmación; modal no toca estado.

## Fase 4 — METAR en vivo
- [x] S4.1 `MetarService` con cliente inyectable, candidatos LEBT→LEVC→LEAL,
      regex QNH, `fromLive`.
      ✔ Tests de parseo con METARs reales; sin red → fail-closed.
- [x] S4.2 `MetarNotifier` async al arranque (no bloquea UI) + chip inline en
      ALTÍMETRO.
      ✔ Arranque sin red muestra checklist inmediatamente, sin chip.

## Fase 5 — Calidad y release
- [x] S5.1 Suite completa + `flutter analyze` limpio.
      ✔ CI en verde. Suites y criterios por test: **[Testing](../testing.md)** (doc canónico).
- [x] S5.2 endurecido Android: `allowBackup=false`, sin cleartext.
      ✔ Escáneres de seguridad → DefectDojo sin hallazgos críticos.
- [x] S5.3 SonarQube (sast.thempra.net) + coverage.
      ✔ Umbral de cobertura del gate de CI alcanzado.
- [x] S5.4 APK firmado (keystore release) versionado `1.0.0+2`, subida a
      GitHub (mirror) y Forgejo (origin).
      ✔ `git log` limpio; artefactos de Play fuera del repo.

## Reglas para el agente al extender (v2)
1. Cualquier cambio de contenido del checklist = editar SOLO `checklist_data.dart`
   y pasar los tests de integridad.
2. Cambiar la regla de la puerta exige actualizar test + flow.md + PRD en el
   MISMO commit (nunca silencioso).
3. Pasos nuevos: respetar el orden de fases; la implementación nunca precede a
   la decisión de diseño.
