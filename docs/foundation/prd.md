# PRD — Tecnam P92 Echo · Pre-flight Checklist (EC-DG4)

> Documento de requisitos de producto. Estado: aprobado y construido (v1.0.0+2).
> Docs hermanas: `trd.md`, `flow.md`, `design-brief.md`, `backend-schema.md`, `implementation-plan.md`.

## 1. Resumen de la idea

App móvil (Flutter, Android) que digitaliza el checklist de papel de pre/post-vuelo
del **Tecnam P92 Echo** con matrícula **EC-DG4**, transcrito fielmente del dossier
de la organización de entrenamiento ULR. Pensada para el piloto en cabina:
un solo pulgar, objetivos táctiles grandes y una **barrera de despegue dura** que
aplica la regla cardinal de la operación:

> **No se despega hasta que esté chequeado TODO el checklist.**

## 2. Problema que resuelve

- El papel se pierde, no persiste el progreso y no impide saltarse pasos.
- La decisión de "¿ya puedo despegar?" la tomaba el criterio del piloto; la app
  la convierte en una puerta mecánica.
- El ajuste del altímetro (QNH) obligaba a buscarlo aparte; ahora aparece en vivo
  en la propia partida del checklist.

## 3. Público

Piloto único propietario (uso personal), vuelo VFR/ULM desde la base
Olocau/Bétera (Valencia, España). Sin multiusuario, sin cuentas.

## 4. Funcionalidades (inventario completo)

### F1. Checklist por bloques (fuente de verdad única)
- **9 bloques** en orden de piloto (Revisión exterior → … → Parada de motor);
  tabla completa: **[Backend schema §6](backend-schema.md)** (doc canónico).
- ~92 entradas (partidas chequeables + cabeceras no táctiles) definidas en un
  único fichero de datos; la UI se renderiza genéricamente desde el modelo.
- **Fidelidad al dossier**: mismos títulos, mismos textos, mismas notas
  (ON/OFF/CHK, 15°, 2.500…). La app nunca inventa ni reordena contenido.

### F2. Navegación multi-página
- Una pantalla por bloque, con indicador de pasos (step indicator) y barra de
  progreso superior. Sin botones prev/next: todo el espacio vertical es para partidas.
- Atajo "saltar al primer pendiente".

### F3. Puerta de despegue (hard gate) — regla de seguridad
- Botón **DESPEGAR** fijado abajo, **bloqueado** mientras quede alguna partida
  pendiente en los bloques 1–7; muestra cuántas faltan.
- Al desbloquearse y pulsarse, la app entra en **fase de aterrizaje**: la puerta
  pasa a **ATERRIZADO** y solo se libera con el checklist completo (bloques 8–9 incluidos).

### F4. Altimétrómetro en vivo (QNH)
- La partida ALTÍMETRO muestra el QNH real del aeropuerto alcanzable más cercano
  (LEBT → LEVC → LEAL), obtenido del METAR público de VATSIM (sin API key).
- Formato inline: `LEBT 1021 hPa`. **Fail-closed**: sin red/no parseable, no se
  muestra valor en vivo (se indica fallback Bétera solo cuando aplica el valor por defecto).

### F5. Persistencia local
- El progreso (ids marcados + fase de vuelo) sobrevive a reinicios de la app.

### F6. Reset con confirmación
- Botón de reinicio con diálogo de confirmación (destructivo, color danger).

### F7. Referencia de parámetros de motor
- Modal con los parámetros del motor como consulta rápida durante la prueba de motor.

### F8. Tests automatizados
- Suite que cubre integridad de datos, lógica de la puerta (despegue/aterrizaje/
  reset) y parseo de METAR/QNH. Detalle por suite: **[Testing](../testing.md)** (doc canónico).

## 5. Fuera de alcance (explícito)
- Sync en la nube, backend remoto o multi-dispositivo.
- Cuentas de usuario / autenticación.
- iOS, tablet, wearables (Android teléfono es el objetivo).
- Fases en vuelo/crucero (solo pre-vuelo, despegue, aproximación y parada).
- NOTAMs, peso & balance, navegación, clima además del QNH.

## 6. Criterios de éxito
1. Cero partidas inventadas: diff de contenido = 0 contra el dossier.
2. La puerta de despegue es matemáticamente imposible de saltar (test lo cubre).
3. Uso con una mano, guantes ligeros: áreas táctiles ≥ 48 dp.
4. Progreso intacto tras matar y reabrir la app.

## 7. Preguntas abiertas
- ¿Registro de vuelos históricos (cuántos despegues autorizados)? → no solicitado; queda fuera de v1.
- ¿Value add del METAR completo (viento/TEMP) en el futuro? → no; solo QNH en v1.
