import 'package:flutter/material.dart';

import '../state/metar_notifier.dart';
import '../theme/app_theme.dart';
import 'marquee.dart';

/// Live METAR ticker shown at the top under the app bar, occupying the
/// space that previously held the radio frequencies.
///
/// Displays the nearest airport's current METAR as a scrolling marquee
/// (e.g. "LEBT 062200Z AUTO VRB02KT CAVOK 24/07 Q1021"). While loading it
/// shows a placeholder; if the network is unavailable it shows the fallback
/// Bétera value.
class MetarBar extends StatelessWidget {
  final MetarNotifier metar;

  const MetarBar({super.key, required this.metar});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: metar,
      builder: (context, _) {
        final result = metar.result;
        final String text;
        final Color color;

        if (result != null) {
          if (result.metar != null) {
            text = '● ${result.name.toUpperCase()} (${result.icao})  METAR: '
                '${result.metar}';
            color = result.fromLive
                ? AppColors.textMuted
                : AppColors.warning; // fallback value
          } else {
            text = '● ${result.name.toUpperCase()} (${result.icao})  '
                'QNH ${result.qnh} hPa (sin conexión)';
            color = AppColors.warning;
          }
        } else {
          text = '● Consultando METAR del aeropuerto más cercano…';
          color = AppColors.textMuted;
        }

        return Marquee(
          text: text,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: color,
          ),
          background: AppColors.background,
          speed: 45,
        );
      },
    );
  }
}
