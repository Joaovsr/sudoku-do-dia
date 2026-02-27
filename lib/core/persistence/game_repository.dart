import 'package:shared_preferences/shared_preferences.dart';

import '../models/day_record.dart';

class GameRepository {
  final SharedPreferences _prefs;

  GameRepository(this._prefs);

  static const _keyPrefix = 'day_';

  String _key(DateTime date) =>
      '$_keyPrefix${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Future<void> saveRecord(DayRecord record) async {
    await _prefs.setString(_key(record.date), record.toJsonString());
  }

  DayRecord? getRecord(DateTime date) {
    final json = _prefs.getString(_key(date));
    if (json == null) return null;
    return DayRecord.fromJsonString(json);
  }

  Map<String, DayStatus> getRecordsForMonth(int year, int month) {
    final result = <String, DayStatus>{};
    final daysInMonth = DateTime(year, month + 1, 0).day;

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      final record = getRecord(date);
      if (record != null && record.status != DayStatus.notStarted) {
        result[record.dateKey] = record.status;
      }
    }

    return result;
  }
}
