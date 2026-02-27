import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/route_transitions.dart';
import '../../app/theme.dart';
import '../../core/providers/calendar_provider.dart';
import '../../core/providers/theme_provider.dart';
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
    Navigator.push(context, fadeSlideRoute(const BoardPage()));
  }

  void _openCalendar(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    ref.read(viewedMonthProvider.notifier).state =
        DateTime(now.year, now.month);
    Navigator.push(context, fadeSlideRoute(const CalendarPage()));
  }

  void _cycleTheme(WidgetRef ref) {
    final current = ref.read(appThemeModeProvider);
    final next = switch (current) {
      AppThemeMode.auto => AppThemeMode.light,
      AppThemeMode.light => AppThemeMode.dark,
      AppThemeMode.dark => AppThemeMode.auto,
    };
    ref.read(appThemeModeProvider.notifier).state = next;
  }

  IconData _themeIcon(AppThemeMode mode) => switch (mode) {
        AppThemeMode.auto => Icons.brightness_auto,
        AppThemeMode.light => Icons.light_mode,
        AppThemeMode.dark => Icons.dark_mode,
      };

  String _themeLabel(AppThemeMode mode) => switch (mode) {
        AppThemeMode.auto => 'Auto',
        AppThemeMode.light => 'Claro',
        AppThemeMode.dark => 'Escuro',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now();
    final c = context.colors;
    final themeMode = ref.watch(appThemeModeProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),

              // Botao de tema no canto superior direito
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () => _cycleTheme(ref),
                  tooltip: _themeLabel(themeMode),
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) => ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                    child: Icon(
                      _themeIcon(themeMode),
                      key: ValueKey(themeMode),
                      color: c.timerColor,
                      size: 22,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              Text(
                'sudoku do dia',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: c.clueColor,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 48),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: c.borderThick, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jogo dirio',
                            style: TextStyle(
                              color: c.clueColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatDate(today),
                            style: TextStyle(
                              color: c.timerColor,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    FilledButton(
                      onPressed: () => _playToday(context, ref),
                      style: FilledButton.styleFrom(
                        backgroundColor: c.userColor,
                        foregroundColor: c.background,
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

              TextButton.icon(
                onPressed: () => _openCalendar(context, ref),
                icon: Icon(
                  Icons.calendar_month_outlined,
                  color: c.timerColor,
                  size: 20,
                ),
                label: Text(
                  'Jogos anteriores',
                  style: TextStyle(
                    color: c.timerColor,
                    fontSize: 15,
                  ),
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
