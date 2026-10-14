# TRD — Requisitos técnicos (p92-checklist)

Plano técnico: stack, herramientas y APIs. Decisiones cerradas; el agente decide
sobre esto sin adivinar.

## 1. Stack

| Área | Decisión | Justificación |
|---|---|---|
| Framework | **Flutter (Dart), SDK ^3.5.4** | Multiplataforma futuro, un solo código, testabilidad |
| Target | **Android (APK release)** | Uso personal en teléfono Android |
| UI kit | Material 3, `ThemeData` propio | Tokens centralizados en `lib/theme/app_theme.dart` |
| Estado | **`ChangeNotifier` nativo** (sin Riverpod/Bloc) | Superficie de estado mínima; menos dependencias = menos riesgo en app de seguridad |
| Persistencia | **`shared_preferences` ^2.2.0** | Solo necesita un set de ids + flag de fase; sin DB |
| HTTP | **`http` ^1.6.0** | Un único GET textual; sin dio/retrofit |
| Tests | `flutter_test` | 20 tests, 3 suites |
| Lint | `flutter_lints` + `analysis_options.yaml` | CI |

## 2. Arquitectura (capas)

```
Screens    lib/screens/checklist_screen.dart (orquesta todo)
Widgets    lib/widgets/{step_indicator, block_view, item_row, progress_bar, takeoff_gate}
State      lib/state/{checklist_store, metar_notifier}   ChangeNotifier
Services   lib/services/metar_service.dart               I/O externo
Domain     lib/models/*, lib/data/checklist_data.dart    source of truth
Theme      lib/theme/app_theme.dart                      design tokens
```

Regla: las pantallas nunca hardcodean partidas; todo se renderiza desde
`checklist_data.dart`. Los services se inyectan con cliente HTTP configurable
para testear sin red.

## 3. APIs externas

| API | Endpoint | Auth | Notas |
|---|---|---|---|
| METAR VATSIM | `GET https://metar.vatsim.net/metar.php?id=<ICAO>` | ninguna | Devuelve METAR crudo de 1 línea. Parseo del grupo QNH con `\bQ(\d{3,4})\b`. |

Candidatos ordenados por distancia a la base: `LEBT` (Bétera, 2 km) → `LEVC`
(Valencia, 25 km) → `LEAL` (Alicante, 135 km). Se usa el primero alcanzable.
Timeout corto; en fallo, valor por defecto LEBT marcado `fromLive=false` o
ocultar (fail-closed).

## 4. Claves de persistencia (SharedPreferences)

| Clave | Tipo | Contenido |
|---|---|---|
| `checked_ids` | StringList | ids de partidas marcadas |
| `took_off` | bool | fase: ya se autorizó el despegue |

## 5. Build, release y CI

- Versionado: `version: 1.0.0+2` (semver + versionCode).
- Firmado: `release-keystore.jks` + `~/.p92_keystore` (fuera del repo el storepass).
- Play: build vía `tool/` + `.play_build.sh` (logs fuera del repo).
- Repos: `origin` = Forgejo `code.thempra.net/apps/p92-checklist`, espejo `github` Thempra.
- CI: `.forgejo/` workflows; escáneres de seguridad → DefectDojo; SonarQube
  (`sonar-project.properties`) en sast.thempra.net.
- Seguridad AndroidManifest: `allowBackup=false`, sin cleartext traffic.

## 6. Restricciones técnicas
- Sin analytics, sin permisos de red más que el GET METAR (HTTPS).
- Persistencia best-effort: un fallo de SharedPreferences nunca crashea la app.
- La app funciona 100 % sin red salvo el QNH en vivo.
- Higiene: nada de secretos ni artefactos de publicación en el repo.
