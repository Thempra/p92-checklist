# Esquema de backend / datos (p92-checklist)

La app es **local-first sin backend remoto**: no hay servidor propio, no hay
cuentas. "Backend" aquí = modelo de datos, persistencia en dispositivo y el
único flujo de datos externo (METAR).

## 1. Autenticación
**Ninguna (por diseño).** App de un solo piloto, uso personal, sin datos
sensibles en servidor. Sin login, sin tokens, sin sesiones. Si algún día se
sincronizara entre dispositivos, la decisión de casa aplica: login a nivel de
app (token + contraseña por backend), nunca Basic Auth de infraestructura.

## 2. Modelo de dominio (en código, fuente de verdad)

`lib/data/checklist_data.dart` define todo el contenido. No es una BD: es un
fichero tipado inmutable del que derivan UI, estado y tests.

### Entidad `ChecklistItem`
| Campo | Tipo | Notas |
|---|---|---|
| `id` | String | **PK**, único en toda la app (p. ej. `pem_altimetro`). Clave de estado y persistencia. |
| `label` | String | Texto de la acción (ALTÍMETRO,…) |
| `note` | String? | Sufijo (ON, OFF, CHK, 15°, 2.500) |
| `isHeader` | bool | true → cabecera no táctil, no computa como chequeable |

### Entidad `ChecklistGroup` (bloque)
| Campo | Tipo | Notas |
|---|---|---|
| `title` | String | Título completo del bloque |
| `shortTitle` | String | Nombre corto para el step indicator |
| `step` | int 1–9 | Orden de piloto |
| `items` | List\<ChecklistItem\> | FK 1:N, orden de lista = orden visual |

### Relaciones / invariantes (ER)
```
ChecklistGroup (9) --1:N--> ChecklistItem (~92)
kTakeoffLastBlockIndex = 6  → bloques 1..7 gatean el despegue
kTotalCheckableItems        → items con isHeader=false
```
Invariants testeados: ids globalmente únicos · exactamente 9 bloques en orden ·
conteo de chequeables consistente.

## 3. Persistencia en dispositivo (SharedPreferences, clave-valor)

| Clave | Tipo | Esquema | Escritura |
|---|---|---|---|
| `checked_ids` | List\<String\> | ids marcados (solo presentes = true) | best-effort tras cada toggle/reset |
| `took_off` | bool | fase: despegue autorizado | tras cada authorizeTakeoff/reset |

Lectura única en `load()` al arranque. Fallo de lectura → empezar limpio (nunca
crashear). Fallo de escritura → la sesión sigue en memoria.
Migración: si se añadiera esquema, versionar con clave `schema_version`.

## 4. Estado en memoria (`ChecklistStore`, ChangeNotifier)
`Map<String,bool> _checked`, `bool _tookOff`, `bool _isReady`. API pública:
`isChecked, completedCount, preTakeoffComplete, isComplete, progress,
groupCompleted, firstPendingBlockIndex, pendingItems, toggle, setChecked,
authorizeTakeoff, reset, load`.

## 5. Flujo de datos externo (único): METAR → QNH

Decisión: un fetch por arranque + reintento manual, candidatos LEBT→LEVC→LEAL,
fail-closed (sin valor real, sin chip). Cliente HTTP inyectable para tests.
Implementación canónica (regex Q-group, `AltimeterResult`, timeout, permisos):
**[Live METAR / Altimeter](../metar.md)**.

## 6. Tabla de bloques e items especiales (detalle del dominio)

| # | Title (UI) | shortTitle | Fase |
|---|---|---|---|
| 1 | REVISIÓN EXTERIOR | Exterior | Pre-despegue |
| 2 | REVISIÓN EXT. · PLANOS Y COLA | Planos | Pre-despegue |
| 3 | PUESTA EN MARCHA | Arranque | Pre-despegue |
| 4 | DESPUÉS DE ARRANCAR | Post-arranque | Pre-despegue |
| 5 | RODAJE · PRUEBA DE MOTOR | Rodaje | Pre-despegue |
| 6 | ANTES DE DESPEGAR | Pre-despegue | Pre-despegue |
| 7 | BRIEFING | Briefing | Pre-despegue |
| 8 | EN FINAL | Final | Aterrizaje |
| 9 | PARADA DE MOTOR | Parada | Aterrizaje |

Items con comportamiento especial:
- **`pem_altimetro`** — su nota se sustituye por el QNH vivo (`LEBT 1021 hPa`);
  sin dato vivo, sin nota (fail-closed).
- **`pem_radio`** — nota con las VHF: `OLOCAU 130,125 · BÉTERA 126,750 ·
  VALENCIA 120,100`.

Helpers globales en `checklist_data.dart`: `kAllCheckableItems()`,
`kTotalCheckableItems` (actualmente 84 chequeables), `kTakeoffLastBlockIndex` (=6,
bloque 7 BRIEFING). Garantías de integridad exigidas por tests: ids únicos
globales, exactamente 9 bloques en orden de piloto, bloque 2 = planos+cola,
conteo de chequeables consistente.

## 7. Claves cifradas / secretos
- Keystore Android de firma: `release-keystore.jks` + credenciales en
  `~/.p92_keystore` (fuera del repo; nunca subir storepass/keypass).
- La app en sí no almacena secretos. `allowBackup=false`, sin cleartext.
