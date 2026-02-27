import 'package:flutter/material.dart';

import '../../../app/theme.dart';

class SudokuCell extends StatelessWidget {
  final int row;
  final int col;
  final int value; // 0 = vazio
  final bool isClue;
  final bool isSelected;
  final bool isHighlighted;
  final bool hasSameNumber;
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

  Border _border(AppColors c) {
    BorderSide right = BorderSide.none;
    BorderSide bottom = BorderSide.none;

    if (col < 8) {
      final isBlockBoundary = col == 2 || col == 5;
      right = BorderSide(
        color: isBlockBoundary ? c.borderThick : c.borderThin,
        width: isBlockBoundary ? 2.0 : 0.5,
      );
    }

    if (row < 8) {
      final isBlockBoundary = row == 2 || row == 5;
      bottom = BorderSide(
        color: isBlockBoundary ? c.borderThick : c.borderThin,
        width: isBlockBoundary ? 2.0 : 0.5,
      );
    }

    return Border(right: right, bottom: bottom);
  }

  // ── Cor de fundo ──────────────────────────────────────────────────────────

  Color _backgroundColor(AppColors c) {
    if (isSelected) return c.cellSelected;
    if (hasSameNumber) return c.cellSameNumber;
    if (isHighlighted) return c.cellHighlighted;
    return Colors.transparent;
  }

  // ── Cor do texto ──────────────────────────────────────────────────────────

  Color _textColor(AppColors c) {
    if (isClue) return c.clueColor;
    if (hasConflict) return c.errorColor;
    return c.userColor;
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          color: _backgroundColor(c),
          border: _border(c),
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: child,
            ),
            child: value != 0
                ? Text(
                    value.toString(),
                    key: ValueKey(value),
                    style: TextStyle(
                      color: _textColor(c),
                      fontSize: 20,
                      fontWeight: isClue ? FontWeight.w600 : FontWeight.w400,
                    ),
                  )
                : const SizedBox.shrink(key: ValueKey(0)),
          ),
        ),
      ),
    );
  }
}
