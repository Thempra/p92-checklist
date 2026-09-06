import 'package:flutter/material.dart';

import '../data/checklist_data.dart';
import '../state/checklist_store.dart';
import '../theme/app_theme.dart';
import '../widgets/checklist_tile.dart';
import '../widgets/progress_bar.dart';
import '../widgets/takeoff_gate.dart';

/// Main checklist screen.
///
/// Owns the [ChecklistStore] (state lifted to the top of this screen) and
/// renders the full aircraft checklist grouped by block, a progress bar and
/// the take-off gate pinned to the bottom.
class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  final ChecklistStore _store = ChecklistStore();

  @override
  void initState() {
    super.initState();
    _store.load();
  }

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  void _reset() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reiniciar checklist'),
        content: const Text(
            '¿Seguro que quieres desmarcar todos los elementos? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _store.reset();
              Navigator.of(ctx).pop();
            },
            child: const Text(
              'Reiniciar',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CHECKLIST PRE-VUELO'),
        actions: [
          IconButton(
            tooltip: 'Reiniciar checklist',
            icon: const Icon(Icons.refresh),
            onPressed: _reset,
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _store,
        builder: (context, _) {
          return Column(
            children: [
              _FrequenciesHeader(),
              ProgressBar(progress: _store.progress),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(10, 4, 10, 20),
                  children: [
                    for (final group in kAircraft)
                      ChecklistTile.group(
                        title: group.title,
                        store: _store,
                        items: group.items,
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: _store,
        builder: (context, _) =>
            TakeoffGate(store: _store),
      ),
    );
  }
}

/// Small frequency reference taken from the checklist header, always visible
/// so the pilot never has to scroll to confirm radio frequencies.
class _FrequenciesHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: const Row(
        children: [
          Icon(Icons.radio, size: 16, color: AppColors.accent),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              'Olocau 130,125 · Bétera 126,750 · Valencia 120,100',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}
