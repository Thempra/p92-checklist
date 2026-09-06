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
      expect(store.hasTakenOff, isFalse);
      expect(store.preTakeoffComplete, isFalse);
    });

    test('9 flight blocks are defined', () {
      expect(kAircraft.length, 9);
      // step numbers are 1..9 in order
      for (var i = 0; i < kAircraft.length; i++) {
        expect(kAircraft[i].step, i + 1);
      }
    });

    test('preTakeoffComplete unlocks once blocks 1-7 are done', () {
      final store = ChecklistStore();
      // start with the after-takeoff blocks (8,9) already -> still locked
      for (final g in kAircraft.skip(7)) {
        for (final i in g.items) {
          if (!i.isHeader) store.setChecked(i.id, true);
        }
      }
      expect(store.preTakeoffComplete, isFalse,
          reason: 'blocks 8-9 alone must not unlock take-off');

      // now complete blocks 1-7
      for (final g in kAircraft.take(kTakeoffLastBlockIndex + 1)) {
        for (final i in g.items) {
          if (!i.isHeader) store.setChecked(i.id, true);
        }
      }
      expect(store.preTakeoffComplete, isTrue);
      expect(store.hasTakenOff, isFalse);
    });

    test('authorizeTakeoff moves to landing phase', () {
      final store = ChecklistStore();
      // complete blocks 1-7
      for (final g in kAircraft.take(kTakeoffLastBlockIndex + 1)) {
        for (final i in g.items) {
          if (!i.isHeader) store.setChecked(i.id, true);
        }
      }
      store.authorizeTakeoff();
      expect(store.hasTakenOff, isTrue);

      // isComplete false until all blocks (incl. 8,9) done
      expect(store.isComplete, isFalse);
      for (final g in kAircraft.skip(kTakeoffLastBlockIndex + 1)) {
        for (final i in g.items) {
          if (!i.isHeader) store.setChecked(i.id, true);
        }
      }
      expect(store.isComplete, isTrue);
      expect(store.pendingItems, isEmpty);
    });

    test('isComplete only when every item is checked (gate)', () {
      final store = ChecklistStore();
      final all = kAllCheckableItems();
      for (var i = 0; i < all.length - 1; i++) {
        store.setChecked(all[i].id, true);
      }
      expect(store.isComplete, isFalse,
          reason: 'one unchecked item must block completion');
      store.setChecked(all[all.length - 1].id, true);
      expect(store.isComplete, isTrue);
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

    test('reset clears everything and landing phase', () {
      final store = ChecklistStore();
      for (final i in kAllCheckableItems()) {
        store.setChecked(i.id, true);
      }
      store.authorizeTakeoff();
      expect(store.isComplete, isTrue);
      store.reset();
      expect(store.completedCount, 0);
      expect(store.isComplete, isFalse);
      expect(store.hasTakenOff, isFalse);
    });

    test('groupCompleted tracks per-block progress', () {
      final store = ChecklistStore();
      final first = kAircraft.first;
      for (final i in first.items) {
        if (!i.isHeader) store.setChecked(i.id, true);
      }
      expect(store.groupCompleted(first), first.checkableCount);
      expect(store.groupCompleted(kAircraft[1]), 0);
    });

    test('firstPendingBlockIndex points to first incomplete block', () {
      final store = ChecklistStore();
      expect(store.firstPendingBlockIndex, 0);
      // complete the first two blocks -> pending is block 3 (index 2)
      for (var i = 0; i < 2; i++) {
        for (final item in kAircraft[i].items) {
          if (!item.isHeader) store.setChecked(item.id, true);
        }
      }
      expect(store.firstPendingBlockIndex, 2);
    });
  });
}
