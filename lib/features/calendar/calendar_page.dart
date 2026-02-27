import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/route_transitions.dart';
import '../../app/theme.dart';
import '../../core/models/day_record.dart';
import '../../core/providers/calendar_provider.dart';
import '../../core/providers/repository_provider.dart';
import '../board/board_page.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  static const _weekLabels = ['dom', 'seg', 'ter', 'qua', 'qui', 'sex', 'sab'];

  static const _monthNames = [
    '', 'janeiro', 'fevereiro', 'marco', 'abril', 'maio', 'junho',
    'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro',
  ];

  int _daysInMonth(int year, int month) =>
      DateTime(year, month + 1, 0).day;

  int _firstWeekdayIndex(int year, int month) =>
      DateTime(year, month, 1).weekday % 7;

  void _selectDay(BuildContext context, WidgetRef ref, DateTime date) {
    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);
    if (date.isAfter(todayNorm)) return;

    ref.read(selectedDateProvider.notifier).state = date;
    Navigator.push(context, fadeSlideRoute(const BoardPage()));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewed = ref.watch(viewedMonthProvider);
    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);
    final selectedDate = ref.watch(selectedDateProvider);
    final recordsAsync = ref.watch(calendarRecordsProvider);
    final records = recordsAsync.valueOrNull ?? {};
    final c = context.colors;

    final year = viewed.year;
    final month = viewed.month;
    final daysInMonth = _daysInMonth(year, month);
    final firstIndex = _firstWeekdayIndex(year, month);

    final totalCells = firstIndex + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Cabecalho ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: c.clueColor,
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Jogos anteriores',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: c.clueColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // ── Navegacao de mes ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    color: c.timerColor,
                    onPressed: () {
                      final prev = DateTime(year, month - 1);
                      ref.read(viewedMonthProvider.notifier).state = prev;
                    },
                  ),
                  // AnimatedSwitcher para transicao de mes
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      '${_monthNames[month]} de $year',
                      key: ValueKey('$year-$month'),
                      style: TextStyle(
                        color: c.clueColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    color: _canGoNext(viewed, todayNorm)
                        ? c.timerColor
                        : c.borderThin,
                    onPressed: _canGoNext(viewed, todayNorm)
                        ? () {
                            final next = DateTime(year, month + 1);
                            ref.read(viewedMonthProvider.notifier).state = next;
                          }
                        : null,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ── Labels dos dias da semana ────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: _weekLabels.map((label) {
                  return Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: c.timerColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                        decorationColor: c.timerColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 12),

            // ── Grid de dias com transicao ──────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Column(
                  key: ValueKey('grid-$year-$month'),
                  children: List.generate(rows, (rowIndex) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: List.generate(7, (colIndex) {
                          final cellIndex = rowIndex * 7 + colIndex;
                          final dayNumber = cellIndex - firstIndex + 1;
                          final isValidDay =
                              dayNumber >= 1 && dayNumber <= daysInMonth;

                          if (!isValidDay) {
                            return const Expanded(child: SizedBox());
                          }

                          final cellDate = DateTime(year, month, dayNumber);
                          final isToday = cellDate == todayNorm;
                          final isFuture = cellDate.isAfter(todayNorm);
                          final isSelected = cellDate == selectedDate;
                          final dateKey =
                              '$year-${month.toString().padLeft(2, '0')}-${dayNumber.toString().padLeft(2, '0')}';
                          final dayStatus = records[dateKey];

                          return Expanded(
                            child: _DayCell(
                              day: dayNumber,
                              isToday: isToday,
                              isFuture: isFuture,
                              isSelected: isSelected,
                              status: dayStatus,
                              onTap: () =>
                                  _selectDay(context, ref, cellDate),
                            ),
                          );
                        }),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canGoNext(DateTime viewed, DateTime todayNorm) {
    final nextMonth = DateTime(viewed.year, viewed.month + 1);
    return nextMonth.isBefore(DateTime(todayNorm.year, todayNorm.month + 1));
  }
}

// ── Celula de dia ─────────────────────────────────────────────────────────────

class _DayCell extends StatelessWidget {
  final int day;
  final bool isToday;
  final bool isFuture;
  final bool isSelected;
  final DayStatus? status;
  final VoidCallback onTap;

  const _DayCell({
    required this.day,
    required this.isToday,
    required this.isFuture,
    required this.isSelected,
    this.status,
    required this.onTap,
  });

  Color _textColor(AppColors c) {
    if (isFuture) return c.futureDayText;
    if (isToday) return c.userColor;
    return c.clueColor;
  }

  Color? _dotColor(AppColors c) {
    if (status == null) return null;
    switch (status!) {
      case DayStatus.completed:
        return c.completedDayDot;
      case DayStatus.inProgress:
        return c.inProgressDayDot;
      case DayStatus.notStarted:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return GestureDetector(
      onTap: isFuture ? null : onTap,
      child: Container(
        height: 40,
        decoration: isSelected
            ? BoxDecoration(
                border: Border.all(color: c.userColor, width: 1),
                borderRadius: BorderRadius.circular(6),
              )
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day',
              style: TextStyle(
                color: _textColor(c),
                fontSize: 16,
                fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
            if (_dotColor(c) != null)
              Container(
                width: 5,
                height: 5,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: _dotColor(c),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
