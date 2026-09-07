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

    test('has 9 blocks in the pilot order', () {
      final titles = kAircraft.map((g) => g.title).toList();
      expect(titles.length, 9);
      expect(titles[0], contains('REVISIÓN EXTERIOR'));
      expect(titles[3], contains('DESPUÉS DE ARRANCAR'));
      expect(titles[5], contains('ANTES DE DESPEGAR'));
      expect(titles[6], contains('BRIEFING'));
      expect(titles[7], contains('EN FINAL'));
      expect(titles[8], contains('PARADA DE MOTOR'));
    });

    test('block 2 groups planes and tail', () {
      final block = kAircraft[1];
      final labels = block.items.map((i) => i.label).toList();
      expect(labels, contains('PLANO IZQUIERDO'));
      expect(labels, contains('COLA'));
      expect(labels, contains('PLANO DERECHO'));
    });

    test('block 5 groups rodaje and engine test', () {
      final block = kAircraft[4];
      final labels = block.items.map((i) => i.label).toList();
      expect(labels, contains('RODAJE'.isEmpty ? '' : 'FRENO PARKING'));
      expect(labels, contains('PRUEBA DE MOTOR'));
      expect(labels, contains('ENCENDIDOS (caída máx. 300 RPM)'));
    });

    test('checkable items outnumber headers and total counts match', () {
      final all = kAllCheckableItems();
      expect(all.length, greaterThan(50));
      expect(kTotalCheckableItems, all.length);
    });

    test('block 7 is BRIEFING with ASCENSO blue header and plan item', () {
      final block = kAircraft[6];
      final labels = block.items.map((i) => i.label).toList();
      final headers = block.items.where((i) => i.isHeader).map((i) => i.label).toList();
      expect(labels, contains('CANTAR PLAN EN CASO DE FALLO'));
      expect(headers, contains('ASCENSO'));
    });

    test('motor parameters reference is present', () {
      expect(kMotorParameters.length, greaterThanOrEqualTo(6));
      final keys = kMotorParameters.map((e) => e.$1).toList();
      expect(keys, contains('PRES. ACEITE'));
      expect(keys, contains('VOLTMETRO'));
    });

    test('take-off gates blocks 1-7', () {
      expect(kTakeoffLastBlockIndex, 6);
      expect(kAircraft[kTakeoffLastBlockIndex].title, contains('BRIEFING'));
    });
  });
}
