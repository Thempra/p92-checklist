import 'package:flutter/material.dart';

/// App-wide color palette.
///
/// The user's design preference for portals: cream background with a green
/// accent (never cold blue / purple). For an aviation checklist green also
/// doubles as the "everything is safe to take off" signal.
class AppColors {
  static const Color background = Color(0xFFF5F2EE); // crema
  static const Color surface = Color(0xFFFFFFFF);
  static const Color accent = Color(0xFF0C8A6D); // verde
  static const Color accentDark = Color(0xFF086B54);
  static const Color textPrimary = Color(0xFF1F2A24);
  static const Color textMuted = Color(0xFF6B7A72);
  static const Color danger = Color(0xFFC63B3B);
  static const Color warning = Color(0xFFC98A1B);
  static const Color headerBar = Color(0xFF1F2A24); // casi negro
}

/// Builds the application [ThemeData].
ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.background,
  );

  return base.copyWith(
    cardTheme: const CardTheme(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.headerBar,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) return AppColors.accent;
        return Colors.grey.shade400;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.accent.withOpacity(0.4);
        }
        return Colors.grey.shade300;
      }),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.accent,
    ),
  );
}
