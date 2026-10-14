# Documentación — mapa y regla de autoría única

**Regla anti-duplicidad:** cada dato vive en **un solo documento canónico**;
los demás enlazan, nunca copian. Si un dato cambia, se edita su doc canónico y
nada más. Cambios de decisión se hacen en el MISMO commit que el código.

## Capa 1 — Fundaciones (decisiones) · `docs/foundation/`

| # | Doc | Autoría exclusiva (dueño de estos datos) |
|---|---|---|
| 1 | [prd.md](prd.md) | Idea, funcionalidades, alcance in/out, criterios de éxito |
| 2 | [trd.md](trd.md) | Stack y versiones, APIs (qué endpoint), build/release/CI, restricciones |
| 3 | [flow.md](flow.md) | Fases, navegación, comportamiento exacto de cada botón |
| 4 | [design-brief.md](design-brief.md) | **Paleta/tabla de colores canónica**, tipografía, componentes, aspecto de pantallas |
| 5 | [backend-schema.md](backend-schema.md) | **Modelo de datos y entidades**, **claves de persistencia**, flujo METAR (decisión), tabla de bloques, integridad |
| 6 | [implementation-plan.md](implementation-plan.md) | Secuencia de construcción + criterios de aceptación |

## Capa 2 — Referencia de implementación (cómo quedó) · `docs/`

| Doc | Autoría exclusiva |
|---|---|
| [architecture.md](../architecture.md) | Responsabilidades fichero-a-fichero, diagrama de capas, data flow |
| [metar.md](../metar.md) | Regex Q-group, `AltimeterResult`, timeout, permisos Android |
| [testing.md](../testing.md) | Suites de tests, qué cubre cada una, goldens |

> `overview.md`, `data.md` y `ui.md` se **eliminaron**: su contenido (propósito,
> modelo de datos, paleta/pantallas) estaba duplicado de los fundacionales.
> Punto de entrada general: `README.md` de la raíz.
