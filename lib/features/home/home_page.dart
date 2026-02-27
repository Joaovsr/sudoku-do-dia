import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/providers/calendar_provider.dart';
import '../board/board_page.dart';
import '../calendar/calendar_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  void _playToday(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    ref.read(selectedDateProvider.notifier).state =
        DateTime(now.year, now.month, now.day);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BoardPage()),
    );
  }

  void _openCalendar(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    ref.read(viewedMonthProvider.notifier).state =
        DateTime(now.year, now.month);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CalendarPage()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Titulo
              Text(
                'sudoku do dia',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: KuroTheme.clueColor,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 48),

              // Card jogo diario
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: KuroTheme.borderThick, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    // Label + data
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jogo diario',
                            style: TextStyle(
                              color: KuroTheme.clueColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatDate(today),
                            style: TextStyle(
                              color: KuroTheme.timerColor,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Botao Jogar
                    FilledButton(
                      onPressed: () => _playToday(context, ref),
                      style: FilledButton.styleFrom(
                        backgroundColor: KuroTheme.userColor,
                        foregroundColor: KuroTheme.background,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Jogar',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Jogos anteriores
              TextButton.icon(
                onPressed: () => _openCalendar(context, ref),
                icon: Icon(
                  Icons.calendar_month_outlined,
                  color: KuroTheme.timerColor,
                  size: 20,
                ),
                label: Text(
                  'Jogos anteriores',
                  style: TextStyle(
                    color: KuroTheme.timerColor,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
