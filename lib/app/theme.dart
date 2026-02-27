import 'package:flutter/material.dart';

class KuroTheme {
  KuroTheme._();

  static const Color background = Color(0xFF0D0D0D);
  static const Color surface = Color(0xFF161616);

  static const Color clueColor = Color(0xFFFFFFFF);
  static const Color userColor = Color(0xFF00E5FF); // azul neon
  static const Color errorColor = Color(0xFFFF3B3B);

  static const Color cellHighlighted = Color(0xFF1A1A1A); // mesma linha/col/bloco
  static const Color cellSelected = Color(0xFF1A3A50); // célula selecionada
  static const Color cellSameNumber = Color(0xFF1A2E3A); // mesmo número

  static const Color borderThin = Color(0xFF2E2E2E);
  static const Color borderThick = Color(0xFF707070);

  static const Color numpadBg = Color(0xFF1A1A1A);
  static const Color numpadText = Color(0xFFCCCCCC);
  static const Color numpadAction = Color(0xFF111111);

  static const Color timerColor = Color(0xFF888888);

  static ThemeData get theme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        colorScheme: const ColorScheme.dark(
          surface: surface,
          primary: userColor,
          error: errorColor,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'monospace'),
        ),
      );
}
