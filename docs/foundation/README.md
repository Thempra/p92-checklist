# Documentación fundacional — p92-checklist

Los 6 documentos de arranque del proyecto. Se actualizan **en el mismo commit**
que el cambio que los afecta; nunca decisiones en silencio.

| # | Doc | Qué decide |
|---|---|---|
| 1 | [prd.md](prd.md) | Qué producto es: funcionalidades, alcance, regla de seguridad |
| 2 | [trd.md](trd.md) | Stack, arquitectura, APIs, build/CI |
| 3 | [flow.md](flow.md) | Fases, navegación, qué hace cada botón |
| 4 | [design-brief.md](design-brief.md) | Paleta, tipografía, componentes, pantallas |
| 5 | [backend-schema.md](backend-schema.md) | Modelo de datos, persistencia, flujo METAR |
| 6 | [implementation-plan.md](implementation-plan.md) | Secuencia de construcción con criterios de aceptación |

> Nota: estos docs se redactaron a posteriori sobre la v1 ya construida;
> documentan el estado real verificado contra el código (nunca inventado).
> Docs técnicos ampliados viven en `docs/../` (architecture, data, metar, ui, testing).
