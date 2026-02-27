import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/game_provider.dart';
import '../numpad/numpad_widget.dart';
import 'widgets/board_header.dart';
import 'widgets/sudoku_board.dart';

class BoardPage extends ConsumerWidget {
  const BoardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isComplete = ref.watch(gameProvider.select((s) => s.isComplete));

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),

              const BoardHeader(),

              const SizedBox(height: 24),

              const SudokuBoard(),

              const SizedBox(height: 24),

              if (isComplete)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'puzzle concluido',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 14,
                      letterSpacing: 2,
                    ),
                  ),
                ),

              const NumpadWidget(),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
