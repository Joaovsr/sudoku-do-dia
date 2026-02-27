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
    final hintsUsed = ref.watch(gameProvider.select((s) => s.hintsUsed));
    final canUseHint = ref.watch(gameProvider.select((s) => s.canUseHint));
    final puzzleDate = ref.watch(selectedDateProvider);
    final c = context.colors;

    return Column(
      children: [
        // Linha 1: voltar + titulo + dica
        Row(
          children: [
            // Botao voltar
            SizedBox(
              width: 40,
              height: 40,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.arrow_back, color: c.clueColor, size: 22),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // Titulo central
            Expanded(
              child: Text(
                'sudoku do dia',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: c.clueColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
            ),

            // Botao dica
            SizedBox(
              width: 40,
              height: 40,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.lightbulb_outline,
                  color: canUseHint ? c.userColor : c.borderThin,
                  size: 22,
                ),
                onPressed: canUseHint
                    ? () => ref.read(gameProvider.notifier).useHint()
                    : null,
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),

        // Linha 2: data + dicas restantes + timer
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Data
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Text(
                _formatDate(puzzleDate),
                style: TextStyle(
                  color: c.timerColor,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            // Dicas usadas
            Text(
              'Dica $hintsUsed/${GameState.maxHints}',
              style: TextStyle(
                color: c.timerColor,
                fontSize: 12,
              ),
            ),

            // Timer / conclusao
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isComplete
                    ? Row(
                        key: const ValueKey('complete'),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_rounded,
                            color: c.successColor,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatElapsed(elapsed),
                            style: TextStyle(
                              color: c.successColor,
                              fontSize: 14,
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
                          color: c.timerColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 2,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
