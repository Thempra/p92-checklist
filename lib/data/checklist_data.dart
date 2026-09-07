import '../models/checklist_group.dart';
import '../models/checklist_item.dart';

/// Full pre-flight / post-flight checklist for the Tecnam P92 Echo (EC-DG4),
/// transcribed from the aircraft's operational checklist document.
///
/// Grouped into the 9 flight blocks the pilot steps through. Section headers
/// (e.g. "PARTE DE MORRO") render as blue bars exactly like the source
/// document.
const List<ChecklistGroup> kAircraft = [
  // ─── 1 · REVISIÓN EXTERIOR (PARTE DE MORRO) ───────────────────────────
  ChecklistGroup(
    title: 'REVISIÓN EXTERIOR',
    shortTitle: 'Exterior',
    step: 1,
    items: [
      ChecklistItem(
          id: 'ext_tanques',
          label: 'COMPROBAR NIVEL TANQUES VISUALMENTE'),
      ChecklistItem(id: 'ext_nose_hdr', label: 'PARTE DE MORRO', isHeader: true),
      ChecklistItem(id: 'ext_gascolator', label: 'GASCOLATOR', note: 'DRENAR'),
      ChecklistItem(id: 'ext_tren_del', label: 'TREN DELANTERO', note: 'CHK'),
      ChecklistItem(id: 'ext_helice1', label: 'HÉLICE', note: 'CHK'),
      ChecklistItem(
          id: 'ext_aceite_refrig',
          label: 'NIVELES DE ACEITE Y REFRIG.',
          note: 'CHK'),
      ChecklistItem(id: 'ext_capuchones', label: 'CAPUCHONES BUJÍAS', note: 'CHK'),
      ChecklistItem(
          id: 'ext_carburadores',
          label: 'CARBURADORES Y FILTROS',
          note: 'CHK'),
      ChecklistItem(id: 'ext_manchas', label: 'MANCHAS Y PÉRDIDAS', note: 'CHK'),
      ChecklistItem(
          id: 'ext_silentblocs',
          label: 'SILENT BLOCS (motor y radiadores)',
          note: 'CHK'),
      ChecklistItem(id: 'ext_escapes', label: 'SUJECIÓN DE ESCAPES', note: 'CHK'),
      ChecklistItem(id: 'ext_gomas', label: 'GOMAS Y TUBERÍAS', note: 'CHK'),
    ],
  ),
  // ─── 2 · PLANO IZQUIERDO, COLA, PLANO DERECHO ─────────────────────────
  ChecklistGroup(
    title: 'REVISIÓN EXT. · PLANOS Y COLA',
    shortTitle: 'Planos',
    step: 2,
    items: [
      ChecklistItem(id: 'ext_izq_hdr', label: 'PLANO IZQUIERDO', isHeader: true),
      ChecklistItem(id: 'ext_tren_izq', label: 'TREN PRINCIPAL', note: 'CHK'),
      ChecklistItem(id: 'ext_borde_izq', label: 'BORDE DE ATAQUE', note: 'CHK'),
      ChecklistItem(
          id: 'ext_pito_izq',
          label: 'TUBO PITOT Y TOMA ESTÁTICA',
          note: 'CHK'),
      ChecklistItem(id: 'ext_aleron_izq', label: 'ALERÓN (estado y bisagras)'),
      ChecklistItem(id: 'ext_flap_izq', label: 'FLAP (estado y bisagras)', note: 'CHK'),
      ChecklistItem(id: 'ext_cola_hdr', label: 'COLA', isHeader: true),
      ChecklistItem(
          id: 'ext_est_horiz',
          label: 'ESTABILIZADOR HORIZONTAL',
          note: 'CHK'),
      ChecklistItem(
          id: 'ext_compensador',
          label: 'COMPENSADOR (estado y bisagras)',
          note: 'CHK'),
      ChecklistItem(
          id: 'ext_est_vert',
          label: 'ESTABILIZADOR VERTICAL',
          note: 'CHK'),
      ChecklistItem(id: 'ext_der_hdr', label: 'PLANO DERECHO', isHeader: true),
      ChecklistItem(id: 'ext_flap_der', label: 'FLAP (estado y bisagras)', note: 'CHK'),
      ChecklistItem(id: 'ext_aleron_der', label: 'ALERÓN (estado y bisagras)', note: 'CHK'),
      ChecklistItem(id: 'ext_borde_der', label: 'BORDE DE ATAQUE', note: 'CHK'),
      ChecklistItem(id: 'ext_tren_der', label: 'TREN PRINCIPAL', note: 'CHK'),
      ChecklistItem(id: 'ext_estatica_der', label: 'TOMA ESTÁTICA', note: 'CHK'),
    ],
  ),
  // ─── 3 · PUESTA EN MARCHA ─────────────────────────────────────────────
  ChecklistGroup(
    title: 'PUESTA EN MARCHA',
    shortTitle: 'Arranque',
    step: 3,
    items: [
      ChecklistItem(id: 'pem_cinturones', label: 'CINTURONES', note: 'AJUSTAR'),
      ChecklistItem(
          id: 'pem_auriculares',
          label: 'AURICULARES / CLAVIJAS',
          note: 'CHK'),
      ChecklistItem(id: 'pem_puertas', label: 'PUERTAS', note: 'CERRADAS'),
      ChecklistItem(id: 'pem_parking', label: 'FRENO PARKING', note: 'ON'),
      ChecklistItem(id: 'pem_combustible', label: 'LLAVES DE COMBUSTIBLE'),
      ChecklistItem(id: 'pem_gases', label: 'GASES', note: 'MÍNIMO'),
      ChecklistItem(id: 'pem_starter_frio', label: 'STARTER (SI FRÍO)', note: 'ON'),
      ChecklistItem(id: 'pem_contacto', label: 'LLAVE DE CONTACTO', note: 'ON'),
      ChecklistItem(
          id: 'pem_ind_combustible',
          label: 'INDICADORES COMBUSTIBLE',
          note: 'ON'),
      ChecklistItem(id: 'pem_encendidos', label: 'ENCENDIDOS', note: 'ON'),
      ChecklistItem(id: 'pem_arrancar', label: 'SI LIBRE', note: 'ARRANCAR'),
      ChecklistItem(id: 'pem_pres_aceite', label: 'PRESIÓN DE ACEITE'),
      ChecklistItem(id: 'pem_starter_off', label: 'STARTER', note: 'OFF'),
    ],
  ),
  // ─── 4 · DESPUÉS DE ARRANCAR ──────────────────────────────────────────
  ChecklistGroup(
    title: 'DESPUÉS DE ARRANCAR',
    shortTitle: 'Post-arranque',
    step: 4,
    items: [
      ChecklistItem(id: 'pem_param_motor', label: 'PARÁMETROS MOTOR', note: 'CHK'),
      ChecklistItem(
          id: 'pem_rpm_ralenti',
          label: 'RPM RALENTÍ (si OAT < 10°)',
          note: '1 MIN'),
      ChecklistItem(
          id: 'pem_rpm_caliente',
          label: 'RPM (si OAT TEM. < 50°)',
          note: '2.500'),
      ChecklistItem(id: 'pem_master_avionica', label: 'MASTER AVIÓNICA', note: 'ON'),
      ChecklistItem(
          id: 'pem_luces_estrob',
          label: 'LUCES ESTROBOS Y NAV.',
          note: 'ON'),
      ChecklistItem(id: 'pem_altimetro', label: 'ALTÍMETRO', note: 'AJUSTAR'),
      ChecklistItem(id: 'pem_gps', label: 'GPS', note: 'CHK'),
      ChecklistItem(
          id: 'pem_radio',
          label: 'RADIO',
          note: 'OLOCAU 130,125 · BÉTERA 126,750 · VALENCIA 120,100'),
    ],
  ),
  // ─── 5 · RODAJE · PRUEBA DE MOTOR ─────────────────────────────────────
  ChecklistGroup(
    title: 'RODAJE · PRUEBA DE MOTOR',
    shortTitle: 'Rodaje',
    step: 5,
    items: [
      ChecklistItem(id: 'rod_parking_off', label: 'FRENO PARKING', note: 'OFF'),
      ChecklistItem(id: 'rod_frenos', label: 'FRENOS', note: 'CHK'),
      ChecklistItem(id: 'rod_motor_hdr', label: 'PRUEBA DE MOTOR', isHeader: true),
      ChecklistItem(id: 'rod_parking_on', label: 'FRENO PARKING', note: 'ON'),
      ChecklistItem(id: 'rod_param_verde', label: 'PARÁMETROS MOTOR', note: 'VERDE'),
      ChecklistItem(id: 'rod_rpm', label: 'RPM', note: '4.000'),
      ChecklistItem(
          id: 'rod_encendidos',
          label: 'ENCENDIDOS (caída máx. 300 RPM)'),
      ChecklistItem(
          id: 'rod_dif_mag',
          label: 'DIF. RPM ENTRE MAGNETOS',
          note: '≤ 120'),
      ChecklistItem(id: 'rod_param_verde2', label: 'PARÁMETROS MOTOR', note: 'VERDE'),
      ChecklistItem(id: 'rod_ralenti', label: 'RALENTÍ'),
      ChecklistItem(id: 'rod_final_hdr', label: 'FINAL Y MANGA', isHeader: true),
      ChecklistItem(id: 'rod_final_obs', label: 'FINAL Y MANGA', note: 'OBSERVAR'),
    ],
  ),
  // ─── 6 · ANTES DE DESPEGAR ────────────────────────────────────────────
  ChecklistGroup(
    title: 'ANTES DE DESPEGAR',
    shortTitle: 'Pre-despegue',
    step: 6,
    items: [
      ChecklistItem(id: 'rod_flaps15', label: 'FLAPS (OBSERVAR)', note: '15°'),
      ChecklistItem(id: 'rod_mandos', label: 'MANDOS', note: 'LIBRES'),
      ChecklistItem(id: 'rod_compensador', label: 'COMPENSADOR', note: 'NEUTRO'),
      ChecklistItem(id: 'rod_landing_on', label: 'LUZ DE LANDING', note: 'ON'),
      ChecklistItem(
          id: 'rod_llaves_comb',
          label: 'LLAVES DE COMBUSTIBLE',
          note: 'ABIERTAS'),
      ChecklistItem(id: 'rod_bomba_comb', label: 'BOMBA DE COMBUSTIBLE', note: 'ON'),
      ChecklistItem(
          id: 'rod_pres_combustible',
          label: 'PRESIÓN DE COMBUSTIBLE',
          note: 'CHK'),
      ChecklistItem(id: 'rod_puertas', label: 'PUERTAS Y PESTILLOS', note: 'CHK'),
      ChecklistItem(id: 'rod_parking_ant', label: 'FRENO DE PARKING', note: 'OFF'),
    ],
  ),
  // ─── 7 · BRIEFING (cantar plan + ASCENSO) ──────────────────────────────
  ChecklistGroup(
    title: 'BRIEFING',
    shortTitle: 'Briefing',
    step: 7,
    items: [
      ChecklistItem(
          id: 'asc_plan_fallo', label: 'CANTAR PLAN EN CASO DE FALLO'),
      ChecklistItem(id: 'asc_sep', label: 'ASCENSO', isHeader: true),
      ChecklistItem(id: 'asc_flaps', label: 'FLAPS (Vy / Vx)', note: '0 / 15°'),
      ChecklistItem(id: 'asc_vy_vx', label: 'Vy / Vx', note: '120 / 100'),
      ChecklistItem(
          id: 'asc_pres_comb',
          label: 'PRESIÓN COMBUSTIBLE',
          note: 'CHK'),
      ChecklistItem(id: 'asc_pies', label: 'PIES', note: '> 500 PIES AGL'),
      ChecklistItem(id: 'asc_flaps_limpio', label: 'FLAPS (OBSERVAR)', note: 'LIMPIO'),
      ChecklistItem(id: 'asc_landing_off', label: 'LUZ DE LANDING', note: 'OFF'),
      ChecklistItem(id: 'asc_bomba_off', label: 'BOMBA DE COMBUSTIBLE', note: 'OFF'),
      ChecklistItem(id: 'asc_param_verde', label: 'PARÁMETROS MOTOR', note: 'VERDE'),
    ],
  ),
  // ─── 8 · EN FINAL ─────────────────────────────────────────────────────
  ChecklistGroup(
    title: 'EN FINAL',
    shortTitle: 'Final',
    step: 8,
    items: [
      ChecklistItem(id: 'fin_landing_on', label: 'LUZ LANDING', note: 'ON'),
      ChecklistItem(id: 'fin_bomba_on', label: 'BOMBA DE COMBUSTIBLE', note: 'ON'),
      ChecklistItem(id: 'fin_flaps', label: 'FLAPS (OBSERVAR)'),
      ChecklistItem(id: 'fin_velocidad', label: 'VELOCIDAD', note: '0 - FULL'),
    ],
  ),
  // ─── 9 · PARADA DE MOTOR ──────────────────────────────────────────────
  ChecklistGroup(
    title: 'PARADA DE MOTOR',
    shortTitle: 'Parada',
    step: 9,
    items: [
      ChecklistItem(id: 'par_flaps_limpio', label: 'FLAPS (OBSERVAR)', note: 'LIMPIO'),
      ChecklistItem(
          id: 'par_panel_scan',
          label: 'PANEL SCAN (de izq. a derecha)',
          note: 'TODO OFF'),
      ChecklistItem(
          id: 'par_llaves_cerradas',
          label: 'LLAVES DE COMBUSTIBLE',
          note: 'CERRADAS'),
      ChecklistItem(id: 'par_aerovane', label: 'LIBRE AEROVANE', note: 'RELLENAR'),
      ChecklistItem(
          id: 'par_registro_web',
          label: 'REGISTRO DE VUELO EN WEB',
          note: 'RELLENAR'),
      ChecklistItem(id: 'par_llaves_avion', label: 'LLAVES DEL AVIÓN', note: 'COLGAR'),
      ChecklistItem(id: 'par_funda_pito', label: 'FUNDA PITO', note: 'PUESTA'),
      ChecklistItem(
          id: 'par_helice_horiz',
          label: 'HÉLICE EN HORIZONTAL',
          note: 'CHK'),
    ],
  ),
];

/// Normal engine operating parameters shown in the "PARÁMETROS DE MOTOR"
/// help modal (reference values, not checkable items).
const List<(String, String)> kMotorParameters = [
  ('PRES. ACEITE', '0,8 – MAX 7'),
  ('TEMP. ACEITE', 'MIN 50° – MAX 130°'),
  ('PRES. COMBUSTIBLE', '2 – 5 BAR'),
  ('CHT (CULTIVAS)', '0,15 – 0,4'),
  ('EGT (GASES)', '600° – 800°'),
  ('VOLTMETRO', '12 – 14 VOLT'),
];

/// Index (into [kAircraft]) of the first block that gates take-off (inclusive).
/// DESPEGAR unlocks once blocks 1..7 are complete; block 8 (EN FINAL) is the
/// post-take-off landing phase.
const int kTakeoffLastBlockIndex = 6; // 0-based index of block 7 (ASCENSO)

/// Flattened list of every checkable item across all groups, in order.
List<ChecklistItem> kAllCheckableItems() {
  final items = <ChecklistItem>[];
  for (final g in kAircraft) {
    for (final i in g.items) {
      if (!i.isHeader) items.add(i);
    }
  }
  return items;
}

final int kTotalCheckableItems = kAllCheckableItems().length;

/// Human-readable name of the aircraft.
const String kAircraftName = 'TECNAM P92 ECHO — EC-DG4';
const String kOrganizationName = 'Organización de Formación ULR';
