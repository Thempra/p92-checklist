# Google Play — Ficha de la app (rellenar en Play Console)

Toda la información para publicar **Checklist (Tecnam P92 Echo / EC-DG4)** en
Google Play. Cópiala en [Play Console](https://play.google.com/console) →
**Set up app / Main store listing / App content**.

---

## 1. App details (datos de la app)

| Campo | Valor |
|-------|-------|
| **App name** | Checklist — Tecnam P92 Echo |
| **Application ID (package)** | `com.thempra.p92_checklist` |
| **Default language** | Spanish (Spain) |
| **App category** | Tools (or Education, if tutor) |
| **Contact email** | thempra@nousresearch.com |

> El `applicationId` está fijado en `android/app/build.gradle` y **no se puede
> cambiar** después de la primera publicación.

---

## 2. Short description (≤ 80 chars)

```
Checklist prevuelo Tecnam P92 Echo (EC-DG4). Seguridad en cada vuelo.
```

## 3. Full description (listing)

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
• Interfaz de una sola pantalla por bloque, con indicador de pasos y barra
  de progreso.
• Altímetro (QNH) en vivo desde el METAR del aeropuerto más cercano
  (Bétera LEBT, Valencia LEVC...). Sin dato real, no se muestra ningún valor.
• Persistencia local: el progreso se guarda entre vuelos.
• Frecuencias de radio (Olocau, Bétera, Valencia) integradas en el item
  RADIO del paso 4.
• Botón de reinicio con confirmación y una referencia de parámetros de
  motor (presiones y temperaturas).

Perfecta para la instrucción y el vuelo real del P92 Echo.
```

---

## 4. Graphic assets

Google Play requiere:

| Asset | Tamaño | Estado |
|-------|--------|--------|
| **Icon (app)** | 512×512 | `play-assets/icon_512.png` (generar) |
| **Feature graphic** | 1024×500 | `play-assets/feature_graphic.png` (generado) |
| **Phone screenshots** | min 320×470, recomendado 1080×1920 | `play-assets/screenshot_*.png` (usar frames) |
| **7-inch tablet screenshot** | 1280×720 | opcional |
| **10-inch tablet screenshot** | 1920×1200 | opcional |

---

## 5. App content (cuestionarios)
- **Contenido para adultos:** marcada por el desarrollador (No — es un
  checklist de aviación).
- **Target audience:** mayores de 18 años (pilotos).
- **Anuncios:** No.
- **News apps:** No.
- **Permisos:** Solo `INTERNET` (para el METAR/QNH). No hay permisos sensibles.
- **Política de privacidad:** URL requerida si se recogen datos. La app **no
  recoge ni comparte datos personales**; solo consulta el METAR público.
  Si Play la exige, publicar una política simple o marcar "no recoge datos".

---

## 6. Data safety
- **No comparte datos** con terceros.
- **No recoge datos personales**.
- Sola conexión: petición pública al servicio de METAR de VATSIM (responde
  con informes meteorológicos, no con datos del usuario).

---

## 7. Release (subir el AAB)
1. Google Play **exige un Android App Bundle (`.aab`)** firmado para el
   release. Ya está preparado el signing (keystore `release-keystore.jks`).
2. Subir `build/app/outputs/bundle/release/app-release.aab` en
   **Production track**.
3. **Play App Signing**: Google cifra y gestiona la clave; el keystore local
   queda como copia de seguridad. Guardar `release-keystore.jks` y su
   contraseña en un lugar seguro (imprescindible para actualizar).

---

## 8. Versioning (para futuras actualizaciones)
- `versionCode`: entero que se incrementa en cada release subido.
- `versionName`: visible para el usuario (p. ej. `1.0.0`).
- Se definen en `pubspec.yaml` → `version: 1.0.0+1` (versionName+versionCode).

---

## 9. Costes
- **Cuenta de desarrollador Google Play**: una única tarifa de **25 USD**
  (pago único de por vida).

---

## Checklist previa a la subida
- [ ] AAB firmado generado y probado
- [ ] Icono 512×512
- [ ] Feature graphic 1024×500
- [ ] Screenshots (mín. 2 de teléfono)
- [ ] Descripciones corta y larga
- [ ] Datos de contacto
- [ ] Declaración de contenido (privacy, ads, target)
- [ ] Cuenta desarrollador Play creada (25 USD)
- [ ] Política de privacidad (si la exige Play)
