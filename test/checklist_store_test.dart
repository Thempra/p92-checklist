import 'package:flutter_test/flutter_test.dart';
import 'package:p92_checklist/data/checklist_data.dart';
import 'package:p92_checklist/state/checklist_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ChecklistStore', () {
    test('starts empty and incomplete', () {
      final store = ChecklistStore();
      expect(store.completedCount, 0);
      expect(store.isComplete, isFalse);
      expect(store.progress, 0);
    });

    test('isComplete only when every item is checked (take-off gate)', () {
      final store = ChecklistStore();
      final all = kAllCheckableItems();

      // Mark all but one -> not complete
      for (var i = 0; i < all.length - 1; i++) {
        store.setChecked(all[i].id, true);
      }
      expect(store.isComplete, isFalse,
          reason: 'one unchecked item must block take-off');

      // Mark the last one -> complete
      store.setChecked(all[all.length - 1].id, true);
      expect(store.isComplete, isTrue);
      expect(store.pendingItems, isEmpty);
    });

    test('toggle flips state and moves progress', () {
      final store = ChecklistStore();
      final first = kAllCheckableItems().first;
      store.toggle(first.id);
      expect(store.isChecked(first.id), isTrue);
      expect(store.completedCount, 1);
      store.toggle(first.id);
      expect(store.isChecked(first.id), isFalse);
      expect(store.completedCount, 0);
    });

    test('reset clears everything', () {
      final store = ChecklistStore();
      for (final i in kAllCheckableItems()) {
        store.setChecked(i.id, true);
      }
      expect(store.isComplete, isTrue);
      store.reset();
      expect(store.completedCount, 0);
      expect(store.isComplete, isFalse);
    });

    test('groupCompleted tracks per-block progress', () {
      final store = ChecklistStore();
      final firstBlock = kAircraft.first;
      final firstItem = firstBlock.items.firstWhere((i) => !i.isHeader);
      store.setChecked(firstItem.id, true);
      expect(store.groupCompleted(firstBlock), 1);
      expect(store.firstPendingBlockIndex, 0,
          reason: 'first block still has pending items');
    });

    test('firstPendingBlockIndex points to the first incomplete block', () {
      final store = ChecklistStore();
      // Complete the first block fully.
      for (final i in kAircraft.first.items) {
        if (!i.isHeader) store.setChecked(i.id, true);
      }
      expect(store.firstPendingBlockIndex, 1);
    });
  });
}
