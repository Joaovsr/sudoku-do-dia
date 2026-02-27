import 'package:flutter/material.dart';

// ── ThemeExtension com todas as cores semanticas ─────────────────────────────

class AppColors extends ThemeExtension<AppColors> {
  final Color background;
  final Color surface;
  final Color clueColor;
  final Color userColor;
  final Color errorColor;
  final Color cellHighlighted;
  final Color cellSelected;
  final Color cellSameNumber;
  final Color borderThin;
  final Color borderThick;
  final Color numpadBg;
  final Color numpadText;
  final Color numpadAction;
  final Color timerColor;
  final Color successColor;
  final Color completedDayDot;
  final Color inProgressDayDot;
  final Color futureDayText;

  const AppColors({
    required this.background,
    required this.surface,
    required this.clueColor,
    required this.userColor,
    required this.errorColor,
    required this.cellHighlighted,
    required this.cellSelected,
    required this.cellSameNumber,
    required this.borderThin,
    required this.borderThick,
    required this.numpadBg,
    required this.numpadText,
    required this.numpadAction,
    required this.timerColor,
    required this.successColor,
    required this.completedDayDot,
    required this.inProgressDayDot,
    required this.futureDayText,
  });

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? clueColor,
    Color? userColor,
    Color? errorColor,
    Color? cellHighlighted,
    Color? cellSelected,
    Color? cellSameNumber,
    Color? borderThin,
    Color? borderThick,
    Color? numpadBg,
    Color? numpadText,
    Color? numpadAction,
    Color? timerColor,
    Color? successColor,
    Color? completedDayDot,
    Color? inProgressDayDot,
    Color? futureDayText,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      clueColor: clueColor ?? this.clueColor,
      userColor: userColor ?? this.userColor,
      errorColor: errorColor ?? this.errorColor,
      cellHighlighted: cellHighlighted ?? this.cellHighlighted,
      cellSelected: cellSelected ?? this.cellSelected,
      cellSameNumber: cellSameNumber ?? this.cellSameNumber,
      borderThin: borderThin ?? this.borderThin,
      borderThick: borderThick ?? this.borderThick,
      numpadBg: numpadBg ?? this.numpadBg,
      numpadText: numpadText ?? this.numpadText,
      numpadAction: numpadAction ?? this.numpadAction,
      timerColor: timerColor ?? this.timerColor,
      successColor: successColor ?? this.successColor,
      completedDayDot: completedDayDot ?? this.completedDayDot,
      inProgressDayDot: inProgressDayDot ?? this.inProgressDayDot,
      futureDayText: futureDayText ?? this.futureDayText,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      clueColor: Color.lerp(clueColor, other.clueColor, t)!,
      userColor: Color.lerp(userColor, other.userColor, t)!,
      errorColor: Color.lerp(errorColor, other.errorColor, t)!,
      cellHighlighted: Color.lerp(cellHighlighted, other.cellHighlighted, t)!,
      cellSelected: Color.lerp(cellSelected, other.cellSelected, t)!,
      cellSameNumber: Color.lerp(cellSameNumber, other.cellSameNumber, t)!,
      borderThin: Color.lerp(borderThin, other.borderThin, t)!,
      borderThick: Color.lerp(borderThick, other.borderThick, t)!,
      numpadBg: Color.lerp(numpadBg, other.numpadBg, t)!,
      numpadText: Color.lerp(numpadText, other.numpadText, t)!,
      numpadAction: Color.lerp(numpadAction, other.numpadAction, t)!,
      timerColor: Color.lerp(timerColor, other.timerColor, t)!,
      successColor: Color.lerp(successColor, other.successColor, t)!,
      completedDayDot: Color.lerp(completedDayDot, other.completedDayDot, t)!,
      inProgressDayDot: Color.lerp(inProgressDayDot, other.inProgressDayDot, t)!,
      futureDayText: Color.lerp(futureDayText, other.futureDayText, t)!,
    );
  }
}

// ── Acesso rapido via BuildContext ───────────────────────────────────────────

extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}

// ── Paletas ──────────────────────────────────────────────────────────────────

const lightColors = AppColors(
  background: Color(0xFFF5F5F5),
  surface: Color(0xFFFFFFFF),
  clueColor: Color(0xFF1A1A1A),
  userColor: Color(0xFF1565C0),
  errorColor: Color(0xFFD32F2F),
  cellHighlighted: Color(0xFFE8EAF6),
  cellSelected: Color(0xFFBBDEFB),
  cellSameNumber: Color(0xFFE3F2FD),
  borderThin: Color(0xFFE0E0E0),
  borderThick: Color(0xFF9E9E9E),
  numpadBg: Color(0xFFEEEEEE),
  numpadText: Color(0xFF424242),
  numpadAction: Color(0xFFE0E0E0),
  timerColor: Color(0xFF757575),
  successColor: Color(0xFF2E7D32),
  completedDayDot: Color(0xFF4CAF50),
  inProgressDayDot: Color(0xFFFFC107),
  futureDayText: Color(0xFFBDBDBD),
);

const kuroColors = AppColors(
  background: Color(0xFF0D0D0D),
  surface: Color(0xFF161616),
  clueColor: Color(0xFFFFFFFF),
  userColor: Color(0xFF00E5FF),
  errorColor: Color(0xFFFF3B3B),
  cellHighlighted: Color(0xFF1A1A1A),
  cellSelected: Color(0xFF1A3A50),
  cellSameNumber: Color(0xFF1A2E3A),
  borderThin: Color(0xFF2E2E2E),
  borderThick: Color(0xFF707070),
  numpadBg: Color(0xFF1A1A1A),
  numpadText: Color(0xFFCCCCCC),
  numpadAction: Color(0xFF111111),
  timerColor: Color(0xFF888888),
  successColor: Color(0xFF69F0AE),
  completedDayDot: Color(0xFF4CAF50),
  inProgressDayDot: Color(0xFFFFC107),
  futureDayText: Color(0xFF707070),
);

// ── Builders de ThemeData ────────────────────────────────────────────────────

ThemeData buildLightTheme() => ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightColors.background,
      colorScheme: ColorScheme.light(
        surface: lightColors.surface,
        primary: lightColors.userColor,
        error: lightColors.errorColor,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(fontFamily: 'monospace'),
      ),
      extensions: const [lightColors],
    );

ThemeData buildDarkTheme() => ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: kuroColors.background,
      colorScheme: ColorScheme.dark(
        surface: kuroColors.surface,
        primary: kuroColors.userColor,
        error: kuroColors.errorColor,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(fontFamily: 'monospace'),
      ),
      extensions: const [kuroColors],
    );

