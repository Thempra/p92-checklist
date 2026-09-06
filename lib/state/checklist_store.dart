import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/checklist_data.dart';
import '../models/checklist_group.dart';
import '../models/checklist_item.dart';

/// Central application state for the checklist.
///
/// Holds the checked item ids, persists them across launches, and implements
/// the two-phase flight flow:
///
///  * **Pre-take-off**: take-off ("DESPEGAR") unlocks once every item in
///    blocks 1–7 (Exterior → Ascenso) is complete. Authorising take-off
///    flags the flight as airborne and moves into the landing phase.
///  * **Landing**: the gate now reads "ATERRIZADO" and unlocks once every
///    item across all blocks (including EN FINAL and PARADA DE MOTOR) is done.
class ChecklistStore extends ChangeNotifier {
  final Map<String, bool> _checked = {};
  bool _isReady = false;
  bool _tookOff = false;

  bool get isReady => _isReady;

  /// True once the pilot has authorized take-off (blocks 1–7 done).
  bool get hasTakenOff => _tookOff;

  bool isChecked(String id) => _checked[id] ?? false;

  int get completedCount =>
      kAllCheckableItems().where((i) => isChecked(i.id)).length;

  /// Number of checkable items in the pre-take-off blocks (1–7).
  int get _preTakeoffTotal => kAircraft
      .take(kTakeoffLastBlockIndex + 1)
      .fold<int>(0, (sum, g) => sum + g.checkableCount);

  /// Whether every item in the take-off gating blocks (1–7) is complete.
  bool get preTakeoffComplete {
    final done = kAircraft
        .take(kTakeoffLastBlockIndex + 1)
        .fold<int>(0, (sum, g) => sum + groupCompleted(g));
    return done >= _preTakeoffTotal;
  }

  /// Whether every single checkable item has been completed.
  bool get isComplete => completedCount >= kTotalCheckableItems;

  /// Fraction of completion over all blocks, 0.0..1.0.
  double get progress =>
      kTotalCheckableItems == 0 ? 0 : completedCount / kTotalCheckableItems;

  /// Number of checkable items completed in a given group.
  int groupCompleted(ChecklistGroup group) =>
      group.items.where((i) => !i.isHeader && isChecked(i.id)).length;

  /// Index (into [kAircraft]) of the first incomplete block.
  int get firstPendingBlockIndex {
    for (var i = 0; i < kAircraft.length; i++) {
      if (groupCompleted(kAircraft[i]) < kAircraft[i].checkableCount) return i;
    }
    return 0;
  }

  /// Items still pending (not checked) across all groups.
  List<ChecklistItem> get pendingItems =>
      kAllCheckableItems().where((i) => !isChecked(i.id)).toList();

  void toggle(String id) {
    _checked[id] = !(_checked[id] ?? false);
    _persist();
    notifyListeners();
  }

  void setChecked(String id, bool value) {
    if (_checked[id] == value) return;
    _checked[id] = value;
    _persist();
    notifyListeners();
  }

  /// Authorizes take-off: locks the pre-take-off phase and moves to landing.
  void authorizeTakeoff() {
    _tookOff = true;
    _persist();
    notifyListeners();
  }

  void reset() {
    _checked.clear();
    _tookOff = false;
    _persist();
    notifyListeners();
  }

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList('checked_ids') ?? const [];
      final tookOff = prefs.getBool('took_off') ?? false;
      _checked
        ..clear()
        ..addEntries(saved.map((id) => MapEntry(id, true)));
      _tookOff = tookOff;
    } catch (_) {
      // On failure start fresh rather than crash.
    }
    _isReady = true;
    notifyListeners();
  }

  void _persist() {
    Future(() async {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('checked_ids', _checked.keys.toList());
        await prefs.setBool('took_off', _tookOff);
      } catch (_) {
        // Best-effort persistence.
      }
    });
  }
}
