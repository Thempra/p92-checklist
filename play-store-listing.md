# Google Play — Ficha de la app (textos listos para rellenar)

Todos los campos de texto que pide Google Play para publicar la app
**Checklist — Tecnam P92 Echo**. Copia cada sección tal cual en
[Play Console](https://play.google.com/console).

---

## 1. Información de la app (App info)

Estos campos se rellenan al **crear la app**.

| Campo | Valor |
|-------|-------|
| **Nombre de la app** | Checklist — Tecnam P92 |
| **Nombre de la app en inglés (si aplica)** | Checklist — Tecnam P92 |
| **Tipo de app** | App (aplicación) |
| **Categoría** | Herramientas |
| **Idioma predeterminado** | Español (España) |
| **Application ID (paquete)** | `com.thempra.p92_checklist` |
| **Contacto de soporte** | thempra@nousresearch.com |

> El **Application ID** ya está fijo en el AAB. No se puede cambiar después.

---

## 2. Ficha de la tienda (Main store listing)

### 2a. Descripción corta (Short description)
Máx. **80 caracteres**. Ya cabe:

```
Checklist prevuelo y vuelo del Tecnam P92 Echo. Seguridad en cada vuelo.
```
*(52 caracteres)*

### 2b. Descripción completa (Full description)
Máx. **4000 caracteres**. Texto listo:

```
Checklist digital para el Tecnam P92 Echo (registro EC-DG4), basada en el
dossier de la Organización de Formación ULR. Pensada para el piloto en la
cabina: objetivos de uso grandes, navegación por bloques y una regla de
oro innegociable.

★ LA REGLA: No se despega hasta que toda la lista esté completada.

La app la impone con una puerta de despegue anclada en la parte inferior:
mientras quede algún ítem sin verificar, el botón DESPEGAR permanece
bloqueado y te indica cuántos faltan.

CARACTERÍSTICAS
• 9 bloques de vuelo transcritos del dossier: Revisión exterior, Puesta en
  marcha, Después de arrancar, Rodaje, Antes de despegar, Briefing, En
  final y Parada de motor.
• Una pantalla por bloque, con indicador de pasos y barra de progreso.
• Altímetro (QNH) en vivo desde el METAR del aeropuerto más cercano
  (Bétera LEBT, Valencia LEVC). Sin dato real, no se muestra ningún valor.
• Persistencia local: el progreso se guarda entre vuelos.
• Frecuencias de radio (Olocau, Bétera, Valencia) integradas en el ítem
  RADIO del paso 4.
• Botón de reinicio con confirmación y una referencia de parámetros de
  motor (presiones y temperaturas).

Perfecta para la instrucción y el vuelo real del P92 Echo.
```

### 2c. Idioma de la ficha
Google pide rellenar la ficha, como mínimo, en el **idioma predeterminado**
(español). Opcionalmente puedes activar más idiomas (inglés, etc.).

---

## 3. Recursos gráficos (Graphic assets)

| Asset | Tamaño requerido | Archivo preparado |
|-------|------------------|-------------------|
| **Icono de la app** | 512×512 | `play-assets/icon_512.png` |
| **Imagen de presentación (feature graphic)** | 1024×500 | `play-assets/feature_graphic.png` |
| **Capturas de pantalla del teléfono** | mín. 320×470 / rec. 1080×1920 | `play-assets/screenshot_1.png` (añadir 1-2 más) |
| **Captura de tablet 7"** | 1280×720 | opcional |
| **Captura de tablet 10"** | 1920×1200 | opcional |

---

## 4. Contenido de la app (App content)

### 4a. Cuestionario de la aplicación (App access)
- **¿Requiere la app que los usuarios inicien sesión?** No.
- **¿Hay funciones restringidas (pago, edad, etc.)?** No.

### 4b. Anuncios (Ads)
- **¿Contiene anuncios?** **No.**

### 4c. Contenido y clasificación (Content rating)
Completa el **cuestionario PEGI** (IARC):
- Sin violencia, sin contenido sexual, sin lenguaje ofensivo, sin juego de
  azar, sin compras dentro de la app.
- Resultado esperado: **PEGI 3 / Todos**.

### 4d. Público objetivo (Target audience)
- **Público principal:** mayores de 18 años.
- **¿Dirigido a menores de 13?** No.
- **¿Fomenta actividades con riesgo (aviación)?** Sí, es un checklist de
  pilotaje → marcar la casilla correspondiente dentro del cuestionario
  (actividades de riesgo / formación), bajo la responsabilidad del desarrollador.

### 4e. Política de privacidad (Privacy policy)
- La app **no recoge ni comparte datos personales**.
- **URL de política de privacidad:** requerida por Play (aunque no recojas
  datos). Texto sugerido en la sección 7.

### 4f. Seguridad de los datos (Data safety)
Declara en el formulario:
- **No comparte datos** con terceros.
- **No recoge datos personales.**
- Única conexión de red: petición pública al servicio de METAR de VATSIM
  (devuelve informes meteorológicos, no datos del usuario).

### 4g. Permisos (Permissions)
Solo aparece **INTERNET** (necesario para el QNH/METAR en vivo). No hay
permisos sensibles.

---

## 5. Versión / Release / Producción

### 5a. Subir el AAB
```
build/app/outputs/bundle/release/app-release.aab
```
- Guardado con la clave de firma own (release-keystore.jks).

### 5b. Versión (Release notes / Novedades de la versión)
```
Primera versión pública.
Checklist prevuelo y vuelo del Tecnam P92 Echo (EC-DG4) con puerta de
despegue, altímetro QNH en vivo desde el METAR del aeropuerto más cercano,
9 bloques de vuelo y persistencia local del progreso.
```

---

## 6. Datos de la ficha técnica (App details)

| Campo | Valor |
|-------|-------|
| **Número de versión** | 1.0.0 |
| **Código de versión** | 1 |
| **Formato** | AAB (Android App Bundle) |
| **Dispositivos** | Teléfono |

---

## 7. Política de privacidad (texto listo para publicar)

> **POLÍTICA DE PRIVACIDAD — Checklist Tecnam P92**
>
> La aplicación "Checklist — Tecnam P92 Echo" no recopila, almacena ni
> comparte ningún dato personal de los usuarios.
>
> La única conexión de red que realiza es una consulta pública al servicio
> de informes meteorológicos METAR de VATSIM con el fin de mostrar la
> presión atmosférica (QNH) del aeropuerto más cercano. Este servicio
> devuelve datos meteorológicos públicos y no recibe información del
> usuario.
>
> No se utilizan servicios de analítica, no se muestran anuncios y no se
> solicitan permisos sensibles (localización, contacto, etc.).
>
> Para cualquier duda: thempra@nousresearch.com
>
> Última actualización: septiembre de 2026.

Puedes alojar esta política en un archivo estático (por ejemplo en el repo:
`docs/PRIVACY_POLICY.md`) y publicarlo con GitHub Pages para obtener una URL.

---

## 8. Resumen de valores del AAB ya firmado

- **Application ID:** `com.thempra.p92_checklist`
- **Nombre (label Android):** Checklist
- **Nombre en Play:** Checklist — Tecnam P92
- **versionName:** 1.0.0 / **versionCode:** 1
- **Categoría:** Herramientas
- **Idioma:** Español (España)
- **Cuenta desarrollador:** Thempra (thempra@nousresearch.com)
