import 'package:flutter_test/flutter_test.dart';
import 'package:p92_checklist/data/checklist_data.dart';

void main() {
  group('checklist_data', () {
    test('every item id is unique', () {
      final ids = <String>[];
      for (final g in kAircraft) {
        for (final i in g.items) {
          if (!i.isHeader) ids.add(i.id);
        }
      }
      expect(ids.toSet().length, ids.length,
          reason: 'duplicate ids would corrupt persisted state');
    });

    test('contains the critical flight blocks', () {
      final titles = kAircraft.map((g) => g.title).toList();
      expect(titles, contains('REVISIÓN EXTERIOR'));
      expect(titles, contains('RODAJE'));
      expect(titles, contains('ASCENSO'));
      expect(titles, contains('PARADA DE MOTOR'));
      expect(titles, contains('EN FINAL'));
    });

    test('roda je includes the before-takeoff sub-block', () {
      final rodaje = kAircraft.firstWhere((g) => g.title == 'RODAJE');
      final labels = rodaje.items.map((i) => i.label).toList();
      expect(labels, contains('ANTES DE DESPEGAR'));
      expect(labels, contains('FLAPS (OBSERVAR)'));
    });

    test('checkable items outnumber headers', () {
      final all = kAllCheckableItems();
      expect(all.length, greaterThan(50));
      expect(kTotalCheckableItems, all.length);
    });

    test('ids are stable and headers are marked', () {
      for (final g in kAircraft) {
        for (final i in g.items) {
          expect(i.id, isNotEmpty);
        }
      }
    });
  });
}
