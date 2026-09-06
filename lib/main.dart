import 'package:flutter/material.dart';

import 'screens/checklist_screen.dart';
import 'state/checklist_store.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const P92ChecklistApp());
}

class P92ChecklistApp extends StatelessWidget {
  const P92ChecklistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checklist',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const ChecklistScreen(),
    );
  }
}

/// Convenience accessor used by widgets that need the store, following the
/// "lift state up" practice (store created once in [ChecklistScreen]).
/// Kept here so tests and widgets share a single source of truth.
ChecklistStore createStore() => ChecklistStore();
