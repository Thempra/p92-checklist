import 'package:flutter/material.dart';

import '../data/checklist_data.dart';
import '../state/checklist_store.dart';
import '../state/metar_notifier.dart';
import '../theme/app_theme.dart';
import '../widgets/block_view.dart';
import '../widgets/step_indicator.dart';
import '../widgets/takeoff_gate.dart';

/// Main checklist screen: a multi-screen flow, one page per flight block.
///
/// A [StepIndicator] on top always tells the pilot where they are (current
/// block highlighted) and which blocks they've already completed (green
/// check). A [PageView] (cached, so every step keeps its state) holds the
/// blocks. The flight gate at the bottom is locked until the pre-take-off
/// phase (blocks 1–7) is complete, then unlocks DESPEGAR and switches to
/// ATERRIZADO for the landing phase.
class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key, this.store, this.metar});

  /// Optional injected store/notifier (used by tests). When null, the screen
  /// creates and owns its own.
  final ChecklistStore? store;
  final MetarNotifier? metar;

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  late final ChecklistStore _store = widget.store ?? ChecklistStore();
  late final MetarNotifier _metar = widget.metar ?? MetarNotifier();
  final PageController _pageController = PageController();
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _store.load();
    _metar.ensureLoaded();
  }

  @override
  void dispose() {
    if (widget.store == null) _store.dispose();
    if (widget.metar == null) _metar.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    setState(() => _current = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
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
            child: const Text('Reiniciar', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CHECKLIST'),
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
        builder: (context, _) => Column(
          children: [
            StepIndicator(
              store: _store,
              currentIndex: _current,
              onStepTap: _goTo,
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: kAircraft.length,
                onPageChanged: (i) => setState(() => _current = i),
                itemBuilder: (context, index) => BlockView(
                  group: kAircraft[index],
                  store: _store,
                  metar: _metar,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: _store,
        builder: (context, _) => TakeoffGate(store: _store, onGoToBlock: _goTo),
      ),
    );
  }
}
