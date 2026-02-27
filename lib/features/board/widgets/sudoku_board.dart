import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../core/providers/game_provider.dart';
import 'sudoku_cell.dart';

class SudokuBoard extends ConsumerWidget {
  const SudokuBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);
    final notifier = ref.read(gameProvider.notifier);

    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: context.colors.borderThick, width: 2.5),
        ),
        child: Column(
          children: List.generate(9, (row) {
            return Expanded(
              child: Row(
                children: List.generate(9, (col) {
                  final clueVal = game.puzzle.clueAt(row, col);
                  final isClue = clueVal != 0;
                  final value = isClue ? clueVal : game.userBoard[row][col];

                  return Expanded(
                    child: SudokuCell(
                      row: row,
                      col: col,
                      value: value,
                      isClue: isClue,
                      isSelected: game.isCellSelected(row, col),
                      isHighlighted: game.isCellHighlighted(row, col),
                      hasSameNumber: game.hasSameNumber(row, col),
                      hasConflict: game.conflicts.contains((row, col)),
                      onTap: () => notifier.selectCell(row, col),
                    ),
                  );
                }),
              ),
            );
          }),
        ),
      ),
    );
  }
}
