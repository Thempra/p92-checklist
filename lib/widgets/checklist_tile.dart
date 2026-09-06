import 'package:flutter/material.dart';

import '../models/checklist_item.dart';
import '../state/checklist_store.dart';
import '../theme/app_theme.dart';

/// Builds a whole visual block (header bar + its checkable rows) for one
/// checklist group.
class ChecklistTile {
  const ChecklistTile._();

  /// Renders a group: a dark header bar, then one row per item (skipping
  /// row rendering for in-block header items, which instead become a bold
  /// sub-label inside the card).
  static Widget group({
    required String title,
    required List<ChecklistItem> items,
    required ChecklistStore store,
  }) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Group header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.headerBar,
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 14,
                letterSpacing: 0.8,
              ),
            ),
          ),
          // Items
          for (var i = 0; i < items.length; i++) ...[
            if (items[i].isHeader)
              _SubHeader(label: items[i].label)
            else
              _ItemRow(item: items[i], store: store),
            if (i < items.length - 1 && !items[i].isHeader)
              const Divider(height: 1, indent: 52, color: Color(0xFFECEAE5)),
          ],
        ],
      ),
    );
  }
}

/// Bold sub-label used for in-block headers (e.g. "PARTE DE MORRO").
class _SubHeader extends StatelessWidget {
  const _SubHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 2),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.accentDark,
          fontWeight: FontWeight.w700,
          fontSize: 12.5,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

/// A single checkable row: large tap target with a checkbox on the left and
/// the label + optional note (e.g. "15°", "ON") on the right.
class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item, required this.store});

  final ChecklistItem item;
  final ChecklistStore store;

  @override
  Widget build(BuildContext context) {
    final checked = store.isChecked(item.id);
    return InkWell(
      onTap: () => store.toggle(item.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 24,
              height: 24,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              decoration: BoxDecoration(
                color:
                    checked ? AppColors.accent : AppColors.surface,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: checked ? AppColors.accent : const Color(0xFFC9C4BC),
                  width: 2,
                ),
              ),
              child: checked
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      decoration:
                          checked ? TextDecoration.lineThrough : null,
                      decorationColor: AppColors.accent,
                    ),
                  ),
                  if (item.note != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        item.note!,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: checked
                              ? AppColors.accent
                              : AppColors.textMuted,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
