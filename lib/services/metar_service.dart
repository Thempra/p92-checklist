import 'dart:convert';
import 'package:http/http.dart' as http;

/// Result of an altimeter / METAR lookup.
class AltimeterResult {
  /// ICAO of the airport used, e.g. "LEBT".
  final String icao;

  /// Human name of the airport, e.g. "Bétera".
  final String name;

  /// QNH in hPa, e.g. 1021.
  final int qnh;

  /// The raw METAR string (e.g. "LEBT 062200Z AUTO VRB02KT CAVOK 24/07 Q1021"),
  /// or null when only the fallback value is available.
  final String? metar;

  /// True when the value came from a live METAR fetch; false when it is the
  /// hard-coded default (LEBT) because the network was unavailable.
  final bool fromLive;

  const AltimeterResult({
    required this.icao,
    required this.name,
    required this.qnh,
    this.metar,
    required this.fromLive,
  });

  /// Renders as e.g. "LEBT 1023 hPa".
  String get display => '$icao $qnh hPa';

  @override
  String toString() => display;
}

/// Service that fetches METAR (and the altimeter setting / QNH) from the
/// nearest reachable airport via the public VATSIM METAR endpoint.
///
/// The P92's home field network is around Olocau / Bétera (Valencia, Spain),
/// so the candidate airports are the closest ones. If none can be reached,
/// the default is Bétera (LEBT) — the field the aircraft actually bases at.
class MetarService {
  /// Candidate airports near the aircraft's base, ordered by approximate
  /// distance from Olocau/Bétera. Each entry has its ICAO code and the
  /// approximate distance in km (used to pick the nearest reachable one).
  static const List<({String icao, String name, int distKm})> airports = [
    (icao: 'LEBT', name: 'Bétera', distKm: 2),
    (icao: 'LEVC', name: 'Valencia', distKm: 25),
    (icao: 'LEAL', name: 'Alicante', distKm: 135),
  ];

  static const String defaultIcao = 'LEBT';
  static const String defaultName = 'Bétera';

  final http.Client _client;

  MetarService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches the altimeter (QNH) from the nearest reachable airport,
  /// falling back to Bétera (LEBT) with a default value when unavailable.
  ///
  /// [fallbackQnh] lets callers/tests pin the default hPa; otherwise a
  /// sensible sea-level default (1013) is used.
  Future<AltimeterResult> fetchNearbyAltimeter({int fallbackQnh = 1013}) async {
    // Try each airport nearest-first; the first one that returns a QNH wins.
    for (final airport in airports) {
      try {
        final result = await _fetch(airport.icao);
        if (result != null) {
          return result;
        }
      } catch (_) {
        // Try next airport.
      }
    }
    // No live data: fall back to the default field (Bétera) with the default QNH.
    return AltimeterResult(
      icao: defaultIcao,
      name: defaultName,
      qnh: fallbackQnh,
      metar: null,
      fromLive: false,
    );
  }

  /// Fetches the METAR for a single airport, returning decoded fields, or
  /// null when the response is not a valid METAR (no Q group).
  Future<AltimeterResult?> _fetch(String icao) async {
    final uri = Uri.parse('https://metar.vatsim.net/metar.php?id=$icao');
    final resp = await _client.get(uri).timeout(const Duration(seconds: 8));
    if (resp.statusCode != 200) return null;

    final body = utf8.decode(resp.bodyBytes).trim();
    // METAR Q group looks like "Q1013" (QNH in hPa).
    final match = RegExp(r'\bQ(\d{3,4})\b').firstMatch(body);
    if (match == null) return null;

    return AltimeterResult(
      icao: icao,
      name: _nameFor(icao),
      qnh: int.tryParse(match.group(1)!) ?? 0,
      metar: body,
      fromLive: true,
    );
  }

  String _nameFor(String icao) {
    for (final a in airports) {
      if (a.icao == icao) return a.name;
    }
    return icao;
  }
}
