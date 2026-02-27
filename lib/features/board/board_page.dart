import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/providers/game_provider.dart';
import '../numpad/numpad_widget.dart';
import 'widgets/board_header.dart';
import 'widgets/sudoku_board.dart';

class BoardPage extends ConsumerWidget {
  const BoardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isComplete = ref.watch(gameProvider.select((s) => s.isComplete));
    final c = context.colors;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),

              const BoardHeader(),

              const SizedBox(height: 12),

              const Expanded(
                child: Center(child: SudokuBoard()),
              ),

              const SizedBox(height: 12),

              if (isComplete)
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.8, end: 1.0),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.elasticOut,
                  builder: (context, scale, child) => Transform.scale(
                    scale: scale,
                    child: child,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'puzzle concluido',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: c.successColor,
                        fontSize: 14,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),

              const NumpadWidget(),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
