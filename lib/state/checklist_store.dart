import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/checklist_data.dart';
import '../models/checklist_item.dart';

/// Central application state for the checklist.
///
/// Holds the set of checked item ids, persists them across launches and
/// exposes the logic that gates the "DESPEGAR" action on every item being
/// completed.
class ChecklistStore extends ChangeNotifier {
  /// item id -> whether it is checked.
  final Map<String, bool> _checked = {};

  bool _isReady = false;

  /// True once loaded state has been restored from disk.
  bool get isReady => _isReady;

  bool isChecked(String id) => _checked[id] ?? false;

  /// Number of currently checked checkable items.
  int get completedCount =>
      kAllCheckableItems().where((i) => isChecked(i.id)).length;

  /// Whether every single checkable item has been completed.
  bool get isComplete => completedCount >= kTotalCheckableItems;

  /// Fraction of completion, 0.0..1.0.
  double get progress =>
      kTotalCheckableItems == 0 ? 0 : completedCount / kTotalCheckableItems;

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

  void reset() {
    _checked.clear();
    _persist();
    notifyListeners();
  }

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList('checked_ids') ?? const [];
      _checked
        ..clear()
        ..addEntries(saved.map((id) => MapEntry(id, true)));
    } catch (_) {
      // On failure start fresh rather than crash.
    }
    _isReady = true;
    notifyListeners();
  }

  void _persist() {
    // Fire-and-forget: persistence must never block the UI.
    Future(() async {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('checked_ids', _checked.keys.toList());
      } catch (_) {
        // Best-effort persistence.
      }
    });
  }
}
