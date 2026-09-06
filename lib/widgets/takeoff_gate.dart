import 'package:flutter/material.dart';

import '../data/checklist_data.dart';
import '../state/checklist_store.dart';
import '../theme/app_theme.dart';

/// The flight gate pinned at the bottom of the screen, dual-phase.
///
///  * **Pre-take-off** (`!hasTakenOff`): shows a locked DESPEGAR while any item
///    in blocks 1–7 remains. Once blocks 1–7 are complete it unlocks into an
///    enabled "DESPEGAR" that opens an authorization dialog. Confirming moves
///    the pilot to block 8 (EN FINAL) and switches the gate to landing phase.
///  * **Landing** (`hasTakenOff`): the gate reads "ATERRIZADO"; it unlocks
///    once every item (incl. EN FINAL and PARADA DE MOTOR) is complete.
///
/// It also offers two affordances: a help button that opens the
/// "PARÁMETROS DE MOTOR" reference modal, and a button that jumps to the first
/// pending block.
class TakeoffGate extends StatelessWidget {
  final ChecklistStore store;
  final ValueChanged<int> onGoToBlock;

  const TakeoffGate({super.key, required this.store, required this.onGoToBlock});

  @override
  Widget build(BuildContext context) {
    final landing = store.hasTakenOff;

    if (!landing) return _buildTakeoffGate(context);

    final complete = store.isComplete;
    final pending = store.pendingItems.length;
    return _GateBar(
      background: AppColors.headerBar,
      child: Row(
        children: [
          Icon(
            complete ? Icons.check_circle : Icons.flight_land,
            color: complete ? AppColors.accent : const Color(0xFFE9C46A),
            size: 26,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  complete ? 'Listo para aterrizar' : 'Aterrizaje en curso',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                ),
                Text(
                  complete ? 'Checklist completo' : '$pending pendientes',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            'ATERRIZADO',
            style: TextStyle(
              color: complete ? AppColors.accent : Colors.white38,
              fontWeight: FontWeight.w900,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTakeoffGate(BuildContext context) {
    final complete = store.preTakeoffComplete;

    if (complete) {
      return _GateBar(
        background: AppColors.accent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 6),
            Expanded(
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.accentDark,
                  textStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () => _confirmTakeoff(context),
                icon: const Icon(Icons.flight_takeoff),
                label: const Text('DESPEGAR'),
              ),
            ),
            const SizedBox(width: 6),
          ],
        ),
      );
    }

    final pre = kAircraft
        .take(kTakeoffLastBlockIndex + 1)
        .fold<int>(0, (sum, g) => sum + g.checkableCount);
    final preDone = kAircraft
        .take(kTakeoffLastBlockIndex + 1)
        .fold<int>(0, (sum, g) => sum + store.groupCompleted(g));
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
                const Text(
                  'Despegue bloqueado',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                ),
                Text(
                  '$preDone / $pre para despegar',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          // Help button
          IconButton(
            tooltip: 'PARÁMETROS DE MOTOR',
            color: Colors.white70,
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showMotorParameters(context),
          ),
          const SizedBox(width: 4),
          const Text(
            'DESPEGAR',
            style: TextStyle(
              color: Colors.white38,
              fontWeight: FontWeight.w900,
              fontSize: 13,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  void _showMotorParameters(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'PARÁMETROS DE MOTOR',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Divider(color: AppColors.accent),
              const SizedBox(height: 6),
              for (final (k, v) in kMotorParameters) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(k,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    Text(v,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.accentDark)),
                  ],
                ),
                const SizedBox(height: 10),
              ],
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cerrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmTakeoff(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Autorizar despegue?', textAlign: TextAlign.center),
        content: const Text(
          'Checklist pre-despegue completo. Confirma que autorizas el despegue.',
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
              store.authorizeTakeoff();
              // Move the pilot to EN FINAL (landing phase).
              onGoToBlock(kTakeoffLastBlockIndex + 1);
              _showClearance(context);
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
                'Buen vuelo · EN FINAL te espera.',
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
