import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../core/providers/calendar_provider.dart';
import '../../../core/providers/game_provider.dart';

class BoardHeader extends ConsumerWidget {
  const BoardHeader({super.key});

  static const _months = [
    '', 'jan', 'fev', 'mar', 'abr', 'mai', 'jun',
    'jul', 'ago', 'set', 'out', 'nov', 'dez',
  ];

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} ${_months[d.month]} ${d.year}';

  String _formatElapsed(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final elapsed = ref.watch(gameProvider.select((s) => s.elapsed));
    final isComplete = ref.watch(gameProvider.select((s) => s.isComplete));
    final puzzleDate = ref.watch(selectedDateProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Titulo + data do puzzle
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'sudoku do dia',
              style: TextStyle(
                color: KuroTheme.clueColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _formatDate(puzzleDate),
              style: TextStyle(
                color: KuroTheme.timerColor,
                fontSize: 12,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),

        // Timer / conclusao
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isComplete
              ? Row(
                  key: const ValueKey('complete'),
                  children: [
                    const Icon(
                      Icons.check_rounded,
                      color: Colors.greenAccent,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatElapsed(elapsed),
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                )
              : Text(
                  key: const ValueKey('timer'),
                  _formatElapsed(elapsed),
                  style: TextStyle(
                    color: KuroTheme.timerColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 2,
                  ),
                ),
        ),
      ],
    );
  }
}
