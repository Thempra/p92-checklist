import 'package:flutter/material.dart';

import '../models/checklist_group.dart';
import '../state/checklist_store.dart';
import '../theme/app_theme.dart';
import 'item_row.dart';

/// Renders a single checklist block (one page of the multi-screen flow):
/// its title, a small per-block progress line, all of its items, and
/// prev/next navigation buttons.
class BlockView extends StatelessWidget {
  final ChecklistGroup group;
  final ChecklistStore store;
  final bool isFirst;
  final bool isLast;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  const BlockView({
    super.key,
    required this.group,
    required this.store,
    required this.isFirst,
    required this.isLast,
    this.onPrev,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final total = group.checkableCount;
    final done = store.groupCompleted(group);
    final fraction = total == 0 ? 0.0 : done / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Block header: number + title
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 2),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.headerBar,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${group.step}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  group.title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
        // per-block progress bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: fraction,
                    minHeight: 5,
                    backgroundColor: const Color(0xFFE3E0DA),
                    color: AppColors.accent,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '$done/$total',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        // items card
        Expanded(
          child: Card(
            margin: const EdgeInsets.fromLTRB(10, 6, 10, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < group.items.length; i++) ...[
                  if (group.items[i].isHeader)
                    _SubHeaderRow(label: group.items[i].label)
                  else
                    ItemRow(item: group.items[i], store: store),
                  if (i < group.items.length - 1 && !group.items[i].isHeader)
                    const Divider(
                        height: 1, indent: 52, color: Color(0xFFECEAE5)),
                ],
              ],
            ),
          ),
        ),
        // navigation
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 2, 12, 8),
          child: Row(
            children: [
              if (!isFirst)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onPrev,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('ANTERIOR'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accentDark,
                      side: const BorderSide(color: AppColors.accent),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              if (!isFirst && !isLast) const SizedBox(width: 10),
              if (!isLast)
                Expanded(
                  child: FilledButton(
                    onPressed: onNext,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('SIGUIENTE ›'),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SubHeaderRow extends StatelessWidget {
  final String label;
  const _SubHeaderRow({required this.label});

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
