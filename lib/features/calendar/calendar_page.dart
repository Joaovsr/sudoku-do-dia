import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/providers/calendar_provider.dart';
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

  // Dart: weekday 1=seg ... 7=dom. Grid inicia no dom (indice 0).
  // Conversao: dom=0, seg=1, ..., sab=6
  int _firstWeekdayIndex(int year, int month) =>
      DateTime(year, month, 1).weekday % 7;

  void _selectDay(BuildContext context, WidgetRef ref, DateTime date) {
    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);
    if (date.isAfter(todayNorm)) return; // dias futuros nao sao jogaveis

    ref.read(selectedDateProvider.notifier).state = date;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BoardPage()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewed = ref.watch(viewedMonthProvider);
    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);
    final selectedDate = ref.watch(selectedDateProvider);

    final year = viewed.year;
    final month = viewed.month;
    final daysInMonth = _daysInMonth(year, month);
    final firstIndex = _firstWeekdayIndex(year, month);

    // Total de celulas no grid (preenchido com zeros onde nao ha dia)
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
                    color: KuroTheme.clueColor,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'Jogos anteriores',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // Espaco simetrico ao botao de voltar
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
                    color: KuroTheme.timerColor,
                    onPressed: () {
                      final prev = DateTime(year, month - 1);
                      ref.read(viewedMonthProvider.notifier).state = prev;
                    },
                  ),
                  Text(
                    '${_monthNames[month]} de $year',
                    style: TextStyle(
                      color: KuroTheme.clueColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    color: _canGoNext(viewed, todayNorm)
                        ? KuroTheme.timerColor
                        : KuroTheme.borderThin,
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
                        color: KuroTheme.timerColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                        decorationColor: KuroTheme.timerColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 12),

            // ── Grid de dias ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
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

                        return Expanded(
                          child: _DayCell(
                            day: dayNumber,
                            isToday: isToday,
                            isFuture: isFuture,
                            isSelected: isSelected,
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
  final VoidCallback onTap;

  const _DayCell({
    required this.day,
    required this.isToday,
    required this.isFuture,
    required this.isSelected,
    required this.onTap,
  });

  Color get _textColor {
    if (isFuture) return KuroTheme.borderThick;
    if (isToday) return KuroTheme.userColor;
    return KuroTheme.clueColor;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isFuture ? null : onTap,
      child: Container(
        height: 40,
        decoration: isSelected
            ? BoxDecoration(
                border: Border.all(color: KuroTheme.userColor, width: 1),
                borderRadius: BorderRadius.circular(6),
              )
            : null,
        child: Center(
          child: Text(
            '$day',
            style: TextStyle(
              color: _textColor,
              fontSize: 16,
              fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
