import 'package:flutter/material.dart';

import '../models/checklist_group.dart';
import '../state/checklist_store.dart';
import '../theme/app_theme.dart';
import 'item_row.dart';

/// Renders a single checklist block as a full page of the multi-screen flow.
///
/// Each block is independently scrollable so long lists (e.g. Exterior with
/// 24+ items) can be fully checked. Sub-section headers (e.g. "PARTE DE
/// MORRO") render as blue bars mirroring the source document.
class BlockView extends StatelessWidget {
  final ChecklistGroup group;
  final ChecklistStore store;

  const BlockView({super.key, required this.group, required this.store});

  @override
  Widget build(BuildContext context) {
    final total = group.checkableCount;
    final done = store.groupCompleted(group);
    final fraction = total == 0 ? 0.0 : done / total;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Block header: number + title
          Row(
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
          const SizedBox(height: 6),
          // per-block progress bar
          Row(
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
          const SizedBox(height: 10),
          // items card
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < group.items.length; i++) ...[
                  if (group.items[i].isHeader)
                    _SectionBar(label: group.items[i].label)
                  else
                    ItemRow(item: group.items[i], store: store),
                  if (i < group.items.length - 1 && !group.items[i].isHeader)
                    const Divider(
                        height: 1, indent: 52, color: Color(0xFFECEAE5)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A sub-section header rendered as a blue bar with the section's label,
/// mirroring how the source document groups items under blue backgrounds.
class _SectionBar extends StatelessWidget {
  final String label;
  const _SectionBar({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF3A6B8A), // deep aviation blue
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
