import 'package:flutter/material.dart';

import '../../../app/theme.dart';

class SudokuCell extends StatelessWidget {
  final int row;
  final int col;
  final int value; // 0 = vazio
  final bool isClue;
  final bool isSelected;
  final bool isHighlighted; // mesma linha/coluna/bloco
  final bool hasSameNumber; // mesmo valor que a célula selecionada
  final bool hasConflict;
  final VoidCallback onTap;

  const SudokuCell({
    super.key,
    required this.row,
    required this.col,
    required this.value,
    required this.isClue,
    required this.isSelected,
    required this.isHighlighted,
    required this.hasSameNumber,
    required this.hasConflict,
    required this.onTap,
  });

  // ── Bordas ────────────────────────────────────────────────────────────────

  Border _border() {
    BorderSide right = BorderSide.none;
    BorderSide bottom = BorderSide.none;

    if (col < 8) {
      final isBlockBoundary = col == 2 || col == 5;
      right = BorderSide(
        color: isBlockBoundary ? KuroTheme.borderThick : KuroTheme.borderThin,
        width: isBlockBoundary ? 2.0 : 0.5,
      );
    }

    if (row < 8) {
      final isBlockBoundary = row == 2 || row == 5;
      bottom = BorderSide(
        color: isBlockBoundary ? KuroTheme.borderThick : KuroTheme.borderThin,
        width: isBlockBoundary ? 2.0 : 0.5,
      );
    }

    return Border(right: right, bottom: bottom);
  }

  // ── Cor de fundo ──────────────────────────────────────────────────────────

  Color _backgroundColor() {
    if (isSelected) return KuroTheme.cellSelected;
    if (hasSameNumber) return KuroTheme.cellSameNumber;
    if (isHighlighted) return KuroTheme.cellHighlighted;
    return Colors.transparent;
  }

  // ── Cor do texto ──────────────────────────────────────────────────────────

  Color _textColor() {
    if (isClue) return KuroTheme.clueColor;
    if (hasConflict) return KuroTheme.errorColor;
    return KuroTheme.userColor;
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          color: _backgroundColor(),
          border: _border(),
        ),
        child: Center(
          child: value != 0
              ? AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 120),
                  style: TextStyle(
                    color: _textColor(),
                    fontSize: 20,
                    fontWeight:
                        isClue ? FontWeight.w600 : FontWeight.w400,
                  ),
                  child: Text(value.toString()),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
