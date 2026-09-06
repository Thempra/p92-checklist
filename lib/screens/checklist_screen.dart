import 'package:flutter/material.dart';

import '../data/checklist_data.dart';
import '../state/checklist_store.dart';
import '../theme/app_theme.dart';
import '../widgets/block_view.dart';
import '../widgets/step_indicator.dart';
import '../widgets/takeoff_gate.dart';

/// Main checklist screen: a multi-screen flow, one page per flight block.
///
/// A [StepIndicator] on top always tells the pilot where they are (current
/// block highlighted) and which blocks they've already completed (green
/// check). A [PageView] (cached, so every step keeps its state) holds the
/// blocks, and the take-off gate at the bottom stays locked until every item
/// across all blocks is checked.
class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  final ChecklistStore _store = ChecklistStore();
  final PageController _pageController = PageController();
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _store.load();
  }

  @override
  void dispose() {
    _store.dispose();
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
            const _FrequenciesHeader(),
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
                  isFirst: index == 0,
                  isLast: index == kAircraft.length - 1,
                  onPrev: index > 0 ? () => _goTo(index - 1) : null,
                  onNext: index < kAircraft.length - 1
                      ? () => _goTo(index + 1)
                      : null,
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

/// Small frequency reference taken from the checklist header, always visible
/// so the pilot never has to scroll to confirm radio frequencies.
class _FrequenciesHeader extends StatelessWidget {
  const _FrequenciesHeader();

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
