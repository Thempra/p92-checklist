import 'package:flutter/material.dart';

import '../data/checklist_data.dart';
import '../models/checklist_group.dart';
import '../state/checklist_store.dart';
import '../theme/app_theme.dart';

/// Horizontal step indicator, one small dot per checklist block (9 total).
///
/// The current block is highlighted in green; completed blocks show a green
/// fill; pending (untouched) blocks stay grey. The pilot always sees where
/// they are and how far they've come. Tapping a dot jumps to that block.
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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

  bool _isDone(int index) => store.groupCompleted(kAircraft[index]) >=
      kAircraft[index].checkableCount;
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
    if (done) {
      bg = AppColors.accent;
    } else if (current) {
      bg = AppColors.accent;
    } else if (anyChecked) {
      bg = AppColors.accent.withOpacity(0.18);
    } else {
      bg = const Color(0xFFE3E0DA);
    }

    final size = current ? 34.0 : 26.0;
    return Tooltip(
      message:
          '${group.title} (${store.groupCompleted(group)}/${group.checkableCount})',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            border: current
                ? Border.all(color: AppColors.accentDark, width: 2.5)
                : null,
          ),
          alignment: Alignment.center,
          child: done
              ? const Icon(Icons.check, color: Colors.white, size: 15)
              : Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: done || current ? Colors.white : const Color(0xFF8A877F),
                    fontSize: current ? 15 : 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
        ),
      ),
    );
  }
}

class _Connector extends StatelessWidget {
  final bool done;
  const _Connector({required this.done});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: done ? AppColors.accent : const Color(0xFFDDDAD4),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
