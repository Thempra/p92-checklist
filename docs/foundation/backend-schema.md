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

```
MetarNotifier.load()
  → por ICAO en [LEBT, LEVC, LEAL] (orden distancia):
      GET https://metar.vatsim.net/metar.php?id=<ICAO>   (sin auth, HTTPS)
      200 → regex \bQ(\d{3,4})\b → qnh hPa
      primer éxito gana (aeropuerto alcanzable más cercano)
  → AltimeterResult{icao, name, qnh, metar?, fromLive}
  → UI: chip "LEBT 1021 hPa" en la partida ALTÍMETRO
todo falla → default LEBT fromLive=false / sin chip (fail-closed)
```

Cadencia: un fetch por arranque de app + reintento manual; sin polling agresivo
(ritmo conservador por preferencia de casa). Cliente HTTP inyectable para tests.

## 6. Claves cifradas / secretos
- Keystore Android de firma: `release-keystore.jks` + credenciales en
  `~/.p92_keystore` (fuera del repo; nunca subir storepass/keypass).
- La app en sí no almacena secretos. `allowBackup=false`, sin cleartext.
