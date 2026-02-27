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

class _NumpadButton extends StatefulWidget {
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
  State<_NumpadButton> createState() => _NumpadButtonState();
}

class _NumpadButtonState extends State<_NumpadButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Padding(
      padding: const EdgeInsets.all(4),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.92 : 1.0,
          duration: const Duration(milliseconds: 80),
          curve: Curves.easeInOut,
          child: AnimatedOpacity(
            opacity: _pressed ? 0.7 : 1.0,
            duration: const Duration(milliseconds: 80),
            child: Material(
              color: widget.isAction ? c.numpadAction : c.numpadBg,
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 56,
                child: Center(
                  child: widget.icon != null
                      ? Icon(widget.icon, color: c.timerColor, size: 22)
                      : Text(
                          widget.label!,
                          style: TextStyle(
                            color: c.numpadText,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
