# Checklist Pre-Vuelo — Tecnam P92 Echo (EC-DG4)

Aplicación Flutter de checklist operativo para la fase previa y posterior al
vuelo del Tecnam P92 Echo, transcrito fielmente del dossier de la
Organización de Formación ULR.

## Regla principal

> **No se permite despegar hasta que esté checado TODO el checklist.**

La app refleja esta regla con un **gate de despegue** fijo en la parte inferior:
mientras quede cualquier elemento sin marcar, el botón DESPEGAR permanece
bloqueado y muestra cuántos elementos faltan. Al completarlo todo, se activa un
botón verde de autorización de despegue.

## Características

- Checklist completo por bloques: Revisión exterior, Puesta en marcha, Rodaje,
  Ascenso, En final, Parada de motor, Normal (post-vuelo).
- Marcado por bloque con cabeceras de sección y notas de acción (ON/OFF/CHK/15°…).
- Barra de progreso global con porcentaje.
- Frecuencias de radio (Olocau, Bétera, Valencia) siempre visibles en cabecera.
- **Persistencia**: el progreso se guarda localmente entre sesiones.
- Botón de reinicio con confirmación.
- **9 tests unitarios** que verifican la integridad de los datos y la lógica
  del gate de despegue.

## Arquitectura

Separación por capas para testabilidad y buenas prácticas:

```
lib/
  data/       checklist_data.dart   — checklist completo (fuente de verdad)
  models/     checklist_item.dart, checklist_group.dart — modelo de dominio
  state/      checklist_store.dart  — estado (ChangeNotifier) + lógica del gate
  theme/      app_theme.dart        — paleta crema #F5F2EE + acento verde #0C8A6D
  widgets/    checklist_tile, progress_bar, takeoff_gate — UI reutilizable
  screens/    checklist_screen.dart — pantalla principal
test/
  checklist_data_test.dart   — unicidad de ids, bloques críticos
  checklist_store_test.dart  — gate de despegue, toggle, reset
```

- **Estado**: `ChecklistStore` extiende `ChangeNotifier`; la UI escucha vía
  `ListenableBuilder`. No se usa Provider para minimizar dependencias, pero la
  lógica está aislada del widget y es 100% testeable.
- **Persistencia**: `shared_preferences` (fire-and-forget, no bloquea la UI).
- **El gate es pura lógica**: `store.isComplete` y `store.pendingItems` son
  funciones puras cubiertas por tests.

## Requisitos

- Flutter 3.47+ / Dart 3.5+
- Android SDK (API 33–36)

## Uso

```bash
flutter pub get
flutter test          # 9 tests
flutter run           # ejecutar en dispositivo/emulador
flutter build apk     # generar APK de release
```

## Nota de diseño

Paleta siguiendo la preferencia de portales del usuario: fondo crema `#F5F2EE`,
acento verde `#0C8A6D` (que además refuerza el semáforo "listo para despegar").
Tap targets grandes para operación con guantes y lectura rápida en situación
delicada.
