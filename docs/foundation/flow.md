# Flujo de la app (p92-checklist)

Fases, navegación, recorrido del usuario y qué hace exactamente cada botón.

## 1. Fases del vuelo (máquina de estados)

```
[FRÍO] --abrir app--> [PRE-DESPEGUE] --pulsar DESPEGAR (solo si bloques 1-7 completos)-->
[AIRE / ATERRIZAJE] --pulsar ATERRIZADO (solo si TODO completo)--> [POST-VUELO] 
[CUALQUIERA] --RESET confirmado--> [FRÍO]
```

- **PRE-DESPEGUE**: puerta inferior = `DESPEGAR`, bloqueada con contador
  "Faltan N partidas".
- **AIRE**: solo tras autorizar despegue; bloques 8–9 (EN FINAL, PARADA DE
  MOTOR) son los que quedan por delante. Puerta = `ATERRIZADO`, bloqueada hasta
  checklist completo.
- La fase sobrevive a reinicios (`took_off`).

## 2. Mapa de navegación

```
Splash carga (load() persistencia + fetch METAR async)
   └── Pantalla única orquestadora (ChecklistScreen)
         ├── AppBar: título app · botón parámetros motor (modal) · botón reset
         ├── Step indicator (9 pasos, bloque actual resaltado, pendientes en ámbar)
         ├── Barra de progreso (fracción completada)
         ├── PageView horizontal: 1 página = 1 bloque (swipe)
         ├── ítem "saltar al primer pendiente" (chip/botón)
         └── Puerta DESPEGAR/ATERRIZADO (fija abajo, overlay)
```

No hay router ni pantallas apiladas: una sola pantalla + 2 modales.

## 3. Recorrido pantalla a pantalla

1. **Arranque**: splash breve mientras `load()` lee preferencias y el notifier
   de METAR dispara en background. Si hay progreso guardado, se restaura
   (incluida la fase aire/tierra). Nunca bloquea el arranque por la red.
2. **Bloque activo**: el piloto recorre partidas de arriba abajo, toca cada una
   para marcarla (check verde + fila atenuada). Cabeceras (PRUEBA DE MOTOR…) no
   son táctiles. Swipe horizontal ← → para cambiar de bloque.
3. **Partida ALTÍMETRO**: muestra inline `LEBT 1021 hPa` en cuanto llega el
   METAR; si no hay datos, sin valor en vivo (fail-closed).
4. **Puerta**: mientras `preTakeoffComplete == false`, `DESPEGAR` aparece
   disabled + "Faltan N". Al completarse los bloques 1–7, el botón se ilumina.
5. **Despegue completado, ATERRIZADO**: al terminar bloques 8–9, la puerta
   final libera el cierre del vuelo.

## 4. Qué pasa exactamente al pulsar cada control

| Control | Acción exacta |
|---|---|
| Partida (fila) | `toggle(id)` → invierte estado, persiste best-effort, `notifyListeners()`. Si era la última pendiente de 1–7, la puerta se desbloquea en el mismo frame. |
| **DESPEGAR** (deshabilitado) | No-op. Muestra "Faltan N partidas". |
| **DESPEGAR** (habilitado) | `authorizeTakeoff()` → `tookOff=true`, persiste, la puerta cambia a `ATERRIZADO` (bloqueada), el PageView salta al bloque 8. |
| **ATERRIZADO** (habilitado, todo completo) | Marca el ciclo cerrado visual; el vuelo queda documentado como completo. |
| Swipe horizontal | Cambia de bloque (PageView), actualiza step indicator. |
| Chip "primer pendiente" | `animateToPage(firstPendingBlockIndex)`. |
| Icono parámetros motor (AppBar) | Modal bottom-sheet/dialog con la tabla de parámetros. Cierre por tap fuera o X. Sin efectos en estado. |
| Icono reset (AppBar) | Dialog de confirmación "¿Reiniciar checklist? Se perderá el progreso". **Confirmar** → `reset()`: borra checked, `tookOff=false`, persiste, vuelve al bloque 1. **Cancelar** → cierra sin efectos. |
| Back físico Android | En página >0: retrocede un bloque. En página 0: comportamiento por defecto (salir). |

## 5. Casos borde
- Red caída: checklist completo funciona; ALTÍMETRO sin valor en vivo.
- App matada a mitad: restaura ids + fase exacta.
- Guardar SharedPreferences falla: la sesión sigue en memoria (nunca crashea).
- METAR sin grupo Q parseable: se trata como fallo → fail-closed.
