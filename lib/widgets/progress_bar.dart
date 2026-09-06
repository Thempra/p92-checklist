import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Horizontal progress bar shown under the header.
class ProgressBar extends StatelessWidget {
  final double progress;

  const ProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);
    final pct = (clamped * 100).round();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progreso',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
              Text(
                '$pct%',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.accentDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: clamped,
              minHeight: 8,
              backgroundColor: const Color(0xFFE3E0DA),
            ),
          ),
        ],
      ),
    );
  }
}
