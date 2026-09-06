import '../models/checklist_group.dart';
import '../models/checklist_item.dart';

/// Full pre-flight / post-flight checklist for the Tecnam P92 Echo (EC-DG4),
/// transcribed from the aircraft's operational checklist document.
///
/// Items are ordered top-to-bottom per block, exactly as the pilot flows
/// through them. Header items render as group labels inside a block.
const List<ChecklistGroup> kAircraft = [
  ChecklistGroup(
    title: 'REVISIÓN EXTERIOR',
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
      ChecklistItem(id: 'ext_izq_hdr', label: 'PLANO IZQUIERDO', isHeader: true),
      ChecklistItem(id: 'ext_tren_izq', label: 'TREN PRINCIPAL', note: 'CHK'),
      ChecklistItem(id: 'ext_borde_izq', label: 'BORDE DE ATAQUE', note: 'CHK'),
      ChecklistItem(
          id: 'ext_pito_izq',
          label: 'TUBO PITO Y TOMA ESTÁTICA',
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
  ChecklistGroup(
    title: 'PUESTA EN MARCHA',
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
      ChecklistItem(
          id: 'pem_after_hdr',
          label: 'DESPUÉS DE ARRANCAR',
          isHeader: true),
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
      ChecklistItem(id: 'pem_radio', label: 'RADIO'),
    ],
  ),
  ChecklistGroup(
    title: 'RODAJE',
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
      ChecklistItem(id: 'rod_ant_hdr', label: 'ANTES DE DESPEGAR', isHeader: true),
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
      ChecklistItem(
          id: 'rod_final_hdr',
          label: 'FINAL Y MANGA',
          isHeader: true),
      ChecklistItem(id: 'rod_final_obs', label: 'FINAL Y MANGA', note: 'OBSERVAR'),
    ],
  ),
  ChecklistGroup(
    title: 'ASCENSO',
    items: [
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
  ChecklistGroup(
    title: 'EN FINAL',
    items: [
      ChecklistItem(id: 'fin_landing_on', label: 'LUZ LANDING', note: 'ON'),
      ChecklistItem(id: 'fin_bomba_on', label: 'BOMBA DE COMBUSTIBLE', note: 'ON'),
      ChecklistItem(id: 'fin_flaps', label: 'FLAPS (OBSERVAR)'),
      ChecklistItem(id: 'fin_velocidad', label: 'VELOCIDAD', note: '0 - FULL'),
    ],
  ),
  ChecklistGroup(
    title: 'PARADA DE MOTOR',
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
  ChecklistGroup(
    title: 'NORMAL (POST-VUELO)',
    items: [
      ChecklistItem(id: 'nor_param_motor', label: 'PARÁMETROS MOTOR'),
      ChecklistItem(id: 'nor_pres_aceite', label: 'PRES. ACEITE', note: '0,8 - MAX 7'),
      ChecklistItem(id: 'nor_temp_aceite', label: 'TEMP. ACEITE', note: 'MIN 50° - MAX 130°'),
      ChecklistItem(
          id: 'nor_pres_comb',
          label: 'PRES. COMBUSTIBLE',
          note: '2 - 5 BAR'),
      ChecklistItem(id: 'nor_chts', label: 'CHT (CULTIVAS)', note: '0,15 - 0,4'),
      ChecklistItem(
          id: 'nor_egt',
          label: 'EGT (GASES)',
          note: '600° - 800°'),
      ChecklistItem(
          id: 'nor_voltimetro',
          label: 'VOLTMETRO',
          note: '12 - 14 VOLT'),
    ],
  ),
];

/// Flattened list of every checkable item across all groups, in order.
/// Used to compute overall progress.
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
