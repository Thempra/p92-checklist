import 'package:flutter/foundation.dart';

import '../services/metar_service.dart';

/// Holds the live METAR / altimeter (QNH) value for the nearest airport,
/// fetching it once on startup.
///
/// Exposed as a [ChangeNotifier] so widgets (the marquee bar and the
/// ALTÍMETRO checklist item) can request and observe the value.
class MetarNotifier extends ChangeNotifier {
  final MetarService _service;
  AltimeterResult? _result;
  bool _loading = false;
  bool _started = false;

  MetarNotifier({MetarService? service})
      : _service = service ?? MetarService();

  /// Current altimeter / METAR result, or null before/while loading.
  AltimeterResult? get result => _result;

  bool get isLoading => _loading;

  /// Idempotent kick-off: fetches once. Safe to call from initState.
  Future<void> ensureLoaded() async {
    if (_started || _loading) return;
    _started = true;
    _loading = true;
    notifyListeners();
    try {
      _result = await _service.fetchNearbyAltimeter();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
