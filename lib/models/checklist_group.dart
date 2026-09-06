import 'checklist_item.dart';

/// A group (block) of checklist items, e.g. "REVISIÓN EXTERIOR".
class ChecklistGroup {
  final String title;
  final List<ChecklistItem> items;

  const ChecklistGroup({required this.title, required this.items});

  /// Number of checkable (non-header) items in this group.
  int get checkableCount => items.where((i) => !i.isHeader).length;
}
