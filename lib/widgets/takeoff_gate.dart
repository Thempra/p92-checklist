import 'package:flutter/material.dart';

import '../state/checklist_store.dart';
import '../theme/app_theme.dart';

/// The take-off gate pinned at the bottom of the screen.
///
/// It reflects the *single most important rule* of this checklist: **you
/// cannot take off until every item has been checked**.
///
/// When complete it turns green and enables the DESPEGAR action. While any
/// item remains unchecked it shows how many are still pending and disables
/// the action, so the pilot knows exactly how close they are.
class TakeoffGate extends StatelessWidget {
  final ChecklistStore store;

  const TakeoffGate({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final complete = store.isComplete;
    final pending = store.pendingItems.length;

    if (complete) {
      return _GateBar(
        background: AppColors.accent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 34),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.accentDark,
                  textStyle: const TextStyle(
                      fontSize: 21, fontWeight: FontWeight.w900, letterSpacing: 1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () => _confirmTakeoff(context),
                child: const Text('✓ DESPEGAR'),
              ),
            ),
          ],
        ),
      );
    }

    final c = store.completedCount;
    final t = c + pending;
    return _GateBar(
      background: AppColors.headerBar,
      child: Row(
        children: [
          const Icon(Icons.lock_clock, color: Colors.orangeAccent, size: 26),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  pending == 0
                      ? 'Completando…'
                      : '$pending pendiente${pending == 1 ? '' : 's'}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                ),
                Text(
                  '$c / $t marcados',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const Text(
            'DESPEGAR',
            style: TextStyle(
              color: Colors.white38,
              fontWeight: FontWeight.w900,
              fontSize: 15,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmTakeoff(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Autorizar despegue?', textAlign: TextAlign.center),
        content: const Text(
          'Checklist completo. Confirma que autorizas el despegue.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Aún no'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
            onPressed: () {
              Navigator.of(ctx).pop();
              _showClearance(ctx);
            },
            child: const Text('Confirmar despegue'),
          ),
        ],
      ),
    );
  }

  void _showClearance(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.accent,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.flight_takeoff, color: Colors.white, size: 64),
              const SizedBox(height: 12),
              const Text(
                'DESPEGUE AUTORIZADO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              const Text(
                'Checklist completado. Buen vuelo.',
                style: TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.accentDark,
                ),
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cerrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Full-width bar used both for the locked and unlocked state.
class _GateBar extends StatelessWidget {
  final Color background;
  final Widget child;

  const _GateBar({required this.background, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: background,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: 8 + MediaQuery.of(context).padding.bottom,
      ),
      child: child,
    );
  }
}
