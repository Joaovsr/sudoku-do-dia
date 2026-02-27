import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// auto = baseado na hora (escuro 18h-6h), light = claro, dark = escuro
enum AppThemeMode { auto, light, dark }

final appThemeModeProvider =
    StateProvider<AppThemeMode>((ref) => AppThemeMode.auto);

/// Resolve o ThemeMode efetivo baseado na escolha do usuario.
final resolvedThemeModeProvider = Provider<ThemeMode>((ref) {
  final mode = ref.watch(appThemeModeProvider);
  switch (mode) {
    case AppThemeMode.light:
      return ThemeMode.light;
    case AppThemeMode.dark:
      return ThemeMode.dark;
    case AppThemeMode.auto:
      final hour = DateTime.now().hour;
      final isDark = hour >= 18 || hour < 6;
      return isDark ? ThemeMode.dark : ThemeMode.light;
  }
});
