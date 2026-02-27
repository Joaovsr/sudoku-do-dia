import 'dart:convert';

enum DayStatus { notStarted, inProgress, completed }

class DayRecord {
  final DateTime date;
  final DayStatus status;
  final List<List<int>> boardState;
  final Duration elapsed;

  const DayRecord({
    required this.date,
    required this.status,
    required this.boardState,
    required this.elapsed,
  });

  String get dateKey =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'status': status.index,
        'boardState': boardState,
        'elapsed': elapsed.inSeconds,
      };

  factory DayRecord.fromJson(Map<String, dynamic> json) => DayRecord(
        date: DateTime.parse(json['date'] as String),
        status: DayStatus.values[json['status'] as int],
        boardState: (json['boardState'] as List)
            .map((row) => (row as List).cast<int>())
            .toList(),
        elapsed: Duration(seconds: json['elapsed'] as int),
      );

  String toJsonString() => jsonEncode(toJson());

  static DayRecord fromJsonString(String s) =>
      DayRecord.fromJson(jsonDecode(s) as Map<String, dynamic>);
}
