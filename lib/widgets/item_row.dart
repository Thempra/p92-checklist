import 'package:flutter/material.dart';

import '../models/checklist_item.dart';
import '../state/checklist_store.dart';
import '../theme/app_theme.dart';

/// A single checkable row: large tap target with a checkbox on the left and
/// the label + optional note (e.g. "15°", "ON") on the right.
class ItemRow extends StatelessWidget {
  final ChecklistItem item;
  final ChecklistStore store;

  const ItemRow({super.key, required this.item, required this.store});

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
                color: checked ? AppColors.accent : AppColors.surface,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: checked ? AppColors.accent : const Color(0xFFC9C4BC),
                  width: 2,
                ),
              ),
              child:
                  checked ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
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
                      decoration: checked ? TextDecoration.lineThrough : null,
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
                          color: checked ? AppColors.accent : AppColors.textMuted,
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
