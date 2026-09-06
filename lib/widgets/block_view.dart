import 'package:flutter/material.dart';

import '../models/checklist_group.dart';
import '../state/checklist_store.dart';
import '../state/metar_notifier.dart';
import '../theme/app_theme.dart';
import 'item_row.dart';

/// Renders a single checklist block (one page of the multi-screen flow):
/// its title, a small per-block progress line, and all of its items inside
/// a scrollable card. There are no prev/next buttons — gesture/page swipe
/// navigation frees up vertical space for the items themselves.
class BlockView extends StatelessWidget {
  final ChecklistGroup group;
  final ChecklistStore store;
  final MetarNotifier metar;

  const BlockView({
    super.key,
    required this.group,
    required this.store,
    required this.metar,
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
        // Scrollable items card
        Expanded(
          child: Card(
            margin: const EdgeInsets.fromLTRB(10, 6, 10, 8),
            clipBehavior: Clip.antiAlias,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                for (var i = 0; i < group.items.length; i++) ...[
                  if (group.items[i].isHeader)
                    _SectionBar(label: group.items[i].label)
                  else
                    ItemRow(item: group.items[i], store: store, metar: metar),
                  if (i < group.items.length - 1 && !group.items[i].isHeader)
                    const Divider(
                        height: 1, indent: 52, color: Color(0xFFECEAE5)),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// A full-width section header with a blue background, matching the look of
/// the group bars in the original paper checklist (e.g. "PARTE DE MORRO").
class _SectionBar extends StatelessWidget {
  final String label;
  const _SectionBar({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1F5F8B), // blue bar like the paper checklist
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 13,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
