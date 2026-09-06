/// A single checkable action in the checklist.
///
/// Each item is either a plain checkable action or a non-checkable section
/// header used to visually group actions (e.g. "PARTE DE MORRO").
class ChecklistItem {
  final String id;
  final String label;
  final String? note;

  /// When true this item is a visual grouping header, not something to check.
  final bool isHeader;

  const ChecklistItem({
    required this.id,
    required this.label,
    this.note,
    this.isHeader = false,
  });
}
