import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/providers/game_provider.dart';

class NumpadWidget extends ConsumerWidget {
  const NumpadWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(gameProvider.notifier);
    final isComplete = ref.watch(gameProvider.select((s) => s.isComplete));

    if (isComplete) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Numeros 1-9 em grid 3x3
        for (int row = 0; row < 3; row++)
          Row(
            children: [
              for (int col = 0; col < 3; col++)
                Expanded(
                  child: _NumpadButton.number(
                    label: '${row * 3 + col + 1}',
                    onTap: () => notifier.inputNumber(row * 3 + col + 1),
                  ),
                ),
            ],
          ),
        // Linha de acoes: undo + erase
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _NumpadButton.action(
                icon: Icons.undo_rounded,
                onTap: () => notifier.undo(),
              ),
            ),
            const Expanded(child: SizedBox()),
            Expanded(
              child: _NumpadButton.action(
                icon: Icons.backspace_outlined,
                onTap: () => notifier.clearCell(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _NumpadButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback onTap;
  final bool isAction;

  const _NumpadButton.number({
    required String this.label,
    required this.onTap,
  })  : icon = null,
        isAction = false;

  const _NumpadButton.action({
    required IconData this.icon,
    required this.onTap,
  })  : label = null,
        isAction = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        color: isAction ? KuroTheme.numpadAction : KuroTheme.numpadBg,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: SizedBox(
            height: 56,
            child: Center(
              child: icon != null
                  ? Icon(icon, color: KuroTheme.timerColor, size: 22)
                  : Text(
                      label!,
                      style: const TextStyle(
                        color: KuroTheme.numpadText,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
