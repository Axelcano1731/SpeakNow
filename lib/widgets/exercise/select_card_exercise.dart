import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../models/models.dart';

/// Ejercicio de selección: pregunta arriba y cuadrícula de cartas.
class SelectCardExercise extends StatelessWidget {
  final Exercise exercise;
  final String? selected;
  final bool enabled;
  final ValueChanged<String> onSelected;

  /// Cuando la respuesta ya fue verificada, resalta la correcta
  /// y marca en rojo la elegida si era incorrecta.
  final bool revealAnswer;

  const SelectCardExercise({
    super.key,
    required this.exercise,
    required this.selected,
    required this.enabled,
    required this.onSelected,
    this.revealAnswer = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (exercise.prompt.isNotEmpty) ...[
          Text(
            exercise.prompt,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 24),
        ],
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.15,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (final option in exercise.options)
                _OptionCard(
                  option: option,
                  selected: selected == option.text,
                  enabled: enabled,
                  revealState: _revealStateFor(option),
                  onTap: () => onSelected(option.text),
                ),
            ],
          ),
        ),
      ],
    );
  }

  _RevealState _revealStateFor(CardOption option) {
    if (!revealAnswer) return _RevealState.none;
    if (option.text == exercise.answer) return _RevealState.correct;
    if (option.text == selected) return _RevealState.wrong;
    return _RevealState.none;
  }
}

enum _RevealState { none, correct, wrong }

class _OptionCard extends StatelessWidget {
  final CardOption option;
  final bool selected;
  final bool enabled;
  final _RevealState revealState;
  final VoidCallback onTap;

  const _OptionCard({
    required this.option,
    required this.selected,
    required this.enabled,
    required this.revealState,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Color border = scheme.outline;
    Color bg = scheme.surfaceContainerHighest;
    Color? accentText;

    if (selected) {
      border = AppColors.brandLavender;
      bg = AppColors.brandLavender.withValues(alpha: 0.18);
      accentText = Theme.of(context).brightness == Brightness.dark
          ? AppColors.brandLavender
          : AppColors.brandDeep;
    }
    switch (revealState) {
      case _RevealState.correct:
        border = AppColors.success;
        bg = AppColors.success.withValues(alpha: 0.15);
        accentText = AppColors.successDark;
      case _RevealState.wrong:
        border = AppColors.error;
        bg = AppColors.error.withValues(alpha: 0.12);
        accentText = AppColors.errorDark;
      case _RevealState.none:
        break;
    }

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: border, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: border.withValues(alpha: selected ? 0.9 : 0.5),
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (option.emoji.isNotEmpty) ...[
              Text(option.emoji, style: const TextStyle(fontSize: 36)),
              const SizedBox(height: 8),
            ],
            Flexible(
              child: Text(
                option.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: accentText ?? scheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
