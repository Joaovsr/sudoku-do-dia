import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/day_record.dart';
import '../persistence/game_repository.dart';
import 'calendar_provider.dart';

final repositoryProvider = FutureProvider<GameRepository>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return GameRepository(prefs);
});

/// Status dos dias jogados no mes sendo visualizado no calendario.
final calendarRecordsProvider =
    FutureProvider<Map<String, DayStatus>>((ref) async {
  final repo = await ref.watch(repositoryProvider.future);
  final viewed = ref.watch(viewedMonthProvider);
  return repo.getRecordsForMonth(viewed.year, viewed.month);
});
