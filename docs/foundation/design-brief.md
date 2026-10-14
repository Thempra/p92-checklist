# Brief de diseño (p92-checklist)

Identidad visual en `lib/theme/app_theme.dart`. Estilo: **cálido, legible en
cabina, moderno sobrio** — fondo crema con acento verde (sin azul frío, sin
morados estridentes). Diseñado para un solo pulgar y luz solar.

## 1. Paleta (`AppColors`) — tabla canónica

| Token | Hex | Uso |
|---|---|---|
| `background` | `#F5F2EE` | Fondo crema de página |
| `surface` | `#FFFFFF` | Tarjetas / filas de partida |
| `accent` | `#0C8A6D` | Verde: acción primaria, estado marcado |
| `accentDark` | `#086B54` | Verde presionado/hover |
| `textPrimary` | `#1F2A24` | Texto principal (casi-negro verdoso) |
| `textMuted` | `#6B7A72` | Texto secundario |
| `danger` | `#C63B3B` | Destructivo (reset) |
| `warning` | `#C98A1B` | Ámbar: pendiente / en progreso |
| `headerBar` | `#1F2A24` | AppBar y fondo de la puerta (oscuro) |

## 2. Tipografía y escala
- Fuente: sistema (Roboto) — sin dependencia web; legibilidad > personality.
- Títulos de bloque: 18–20 w700, mayúsculas. Partida: 15–16 w500. Notas
  (ON/OFF/CHK): 13 w500 en `textMuted`, alineadas a la derecha.
- Números del gate/pending: tabulares, w700.

## 3. Tokens de forma y espacio
- Radio tarjetas: **14 px**, elevación **0** (planos, sin sombras duras).
- Espaciado base 8; padding fila 12–16; ancho táctil mínimo **48 dp**.
- Material 3 activo, seed = `accent`.

## 4. Inventario de componentes

| Componente | Estados |
|---|---|
| `ItemRow` | normal → marcado (check verde, label tachado/atenuado) → header (no táctil, banda `textMuted` uppercase) |
| `StepIndicator` | completado (verde sólido) · actual (verde contorno + label) · pendiente (ámbar/gris) |
| `ProgressBar` | 0..1 verde sobre pista crema; texto "N/M" |
| `TakeoffGate` | bloqueado (gris, "Faltan N partidas") · armado (verde, DESPEGAR) · fase aire (fondo oscuro, ATERRIZADO) |
| Botones | Elevated verdes (primario), texto plano (cancelar), `danger` solo reset |
| Modal parámetros motor | tarjeta blanca, tabla clave/valor, cierre X |
| Dialog reset | título pregunta, "Cancelar" (texto) / "Reiniciar" (`danger`) |

## 5. Cómo tiene que verse cada pantalla

**Pantalla única (todos los bloques):**
- AppBar oscura (`headerBar`), texto blanco, iconos a la derecha (motor, reset).
- Debajo: step indicator de 9 puntos/píldoras + barra de progreso fina.
- Cuerpo: página del bloque = lista de tarjetas blancas sobre crema; filas con
  hit-area alta, check a la izquierda o derecha consistente en toda la app.
- Barra flotante inferior a ancho completo: la puerta. Fondo oscuro, botón
  grande; el contador de pendientes en ámbar cuando hay.
- Nada de neón, nada de bordes de 1 px decorativos; el degradado/contraste de
  bloques marca la jerarquía (estilo casa: moderno-formal sobrio).

**ALTÍMETRO (partida especial):** label normal + chip inline verde pálido
`LEBT 1021 hPa` cuando hay dato vivo; ausente si no.

**Modal motor:** fondo oscurecido 40 %, tarjeta centrada, filas parámetro→valor
con separadores crema, números monoespaciados.

**Dialog reset:** ≤ 3 líneas, botón destructivo a la derecha.

## 6. Reglas de accesibilidad / cabina
- Contraste texto/fondo ≥ 4.5:1 (verde sobre crema solo para elementos grandes).
- El estado "marcado" nunca se comunica solo por color: siempre check + atenuado.
- Zona inferior de 96 dp libre para el pulgar (la puerta vive ahí).
- Modo oscuro: fuera de v1 (cockpit de día); el tema claro es el único soportado.
