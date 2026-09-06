import 'package:flutter/material.dart';

import '../data/checklist_data.dart';
import '../models/checklist_group.dart';
import '../state/checklist_store.dart';
import '../theme/app_theme.dart';

/// Horizontal step indicator, one circle per checklist block.
///
/// The current block is highlighted in green with a filled ring; completed
/// blocks show a green check; pending (untouched) blocks stay grey. The
/// pilot always sees where they are and how far they've come. Tapping a
/// completed or adjacent block jumps to it.
class StepIndicator extends StatelessWidget {
  final ChecklistStore store;
  final int currentIndex;
  final ValueChanged<int> onStepTap;

  const StepIndicator({
    super.key,
    required this.store,
    required this.currentIndex,
    required this.onStepTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Row(
        children: [
          for (var i = 0; i < kAircraft.length; i++) ...[
            if (i > 0) Expanded(child: _Connector(done: _isDone(i - 1))),
            _StepDot(
              group: kAircraft[i],
              index: i,
              store: store,
              current: i == currentIndex,
              onTap: () => onStepTap(i),
            ),
          ],
        ],
      ),
    );
  }

  bool _isDone(int index) {
    final g = kAircraft[index];
    return store.groupCompleted(g) >= g.checkableCount;
  }
}

class _StepDot extends StatelessWidget {
  final ChecklistGroup group;
  final int index;
  final ChecklistStore store;
  final bool current;
  final VoidCallback onTap;

  const _StepDot({
    required this.group,
    required this.index,
    required this.store,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final done = store.groupCompleted(group) >= group.checkableCount;
    final anyChecked = store.groupCompleted(group) > 0;

    Color bg;
    Color fg;
    if (done) {
      bg = AppColors.accent;
      fg = Colors.white;
    } else if (current) {
      bg = AppColors.accent;
      fg = Colors.white;
    } else if (anyChecked) {
      bg = AppColors.accent.withOpacity(0.18);
      fg = AppColors.accentDark;
    } else {
      bg = const Color(0xFFE3E0DA);
      fg = const Color(0xFF8A877F);
    }

    // Current block gets a ring + slightly bigger circle.
    final size = current ? 46.0 : 38.0;
    return Tooltip(
      message: '${group.title} (${store.groupCompleted(group)}/${group.checkableCount})',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            border: current
                ? Border.all(color: AppColors.accentDark, width: 3)
                : null,
            boxShadow: current
                ? [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: done
              ? const Icon(Icons.check, color: Colors.white, size: 20)
              : Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: fg,
                    fontSize: current ? 20 : 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
        ),
      ),
    );
  }
}

/// Line linking two adjacent step dots; green when all of the left block's
/// items are done, otherwise grey.
class _Connector extends StatelessWidget {
  final bool done;

  const _Connector({required this.done});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: done ? AppColors.accent : const Color(0xFFDDDAD4),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
