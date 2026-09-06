import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:p92_checklist/services/metar_service.dart';

/// Helper: returns the value of the `id` query param from a METAR request.
String _icao(http.Request req) => req.url.queryParameters['id'] ?? '';

void main() {
  group('MetarService', () {
    test('parses QNH from a live METAR and picks nearest airport first', () async {
      final client = MockClient((request) async {
        final icao = _icao(request);
        if (icao == 'LEBT') {
          return http.Response(
              'LEBT 062200Z AUTO VRB02KT CAVOK 24/07 Q1021', 200);
        }
        return http.Response('', 404);
      });
      final service = MetarService(client: client);
      final result = await service.fetchNearbyAltimeter();

      expect(result.icao, 'LEBT');
      expect(result.qnh, 1021);
      expect(result.fromLive, isTrue);
      expect(result.display, 'LEBT 1021 hPa');
    });

    test('falls back to LEBT default when every airport is unreachable', () async {
      final client = MockClient((request) async => http.Response('', 503));
      final service = MetarService(client: client);
      final result =
          await service.fetchNearbyAltimeter(fallbackQnh: 1013);

      expect(result.icao, 'LEBT');
      expect(result.qnh, 1013);
      expect(result.fromLive, isFalse);
      expect(result.metar, isNull);
    });

    test('skips an airport without a Q group and reaches the next', () async {
      final client = MockClient((request) async {
        final icao = _icao(request);
        // LEBT returns a malformed METAR (no Q). LEVC has the Q.
        if (icao == 'LEBT') {
          return http.Response('LEBT 062200Z AUTO CAVOK', 200);
        }
        if (icao == 'LEVC') {
          return http.Response(
              'LEVC 062200Z 32005KT CAVOK 27/14 Q1021 NOSIG', 200);
        }
        return http.Response('', 404);
      });
      final service = MetarService(client: client);
      final result = await service.fetchNearbyAltimeter();

      expect(result.icao, 'LEVC');
      expect(result.qnh, 1021);
      expect(result.fromLive, isTrue);
    });
  });
}
