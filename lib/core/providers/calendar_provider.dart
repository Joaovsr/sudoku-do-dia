import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/day_record.dart';
import 'game_provider.dart';

/// Data do puzzle sendo jogado. Alterada ao navegar para um dia anterior.
final selectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

/// Mes sendo visualizado no calendario.
final viewedMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month);
});

/// Numero do desafio: dias desde 01/01/2025.
final challengeNumberProvider = Provider<int>((ref) {
  final date = ref.watch(selectedDateProvider);
  final epoch = DateTime(2025, 1, 1);
  return date.difference(epoch).inDays + 1;
});

/// Status do dia selecionado, derivado do game state.
/// Quando persistencia for adicionada, este provider vai ler do repositorio.
final selectedDayStatusProvider = Provider<DayStatus>((ref) {
  final game = ref.watch(gameProvider);
  if (game.isComplete) return DayStatus.completed;
  for (int r = 0; r < 9; r++) {
    for (int c = 0; c < 9; c++) {
      if (game.userBoard[r][c] != 0) return DayStatus.inProgress;
    }
  }
  return DayStatus.notStarted;
});
