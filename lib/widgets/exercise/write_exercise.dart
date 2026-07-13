import 'package:flutter/material.dart';

import '../../models/models.dart';

/// Ejercicio de escritura: traduce la frase y se corrige con
/// tolerancia a errores tipográficos.
class WriteExercise extends StatelessWidget {
  final Exercise exercise;
  final TextEditingController controller;
  final bool enabled;
  final VoidCallback onSubmitted;

  const WriteExercise({
    super.key,
    required this.exercise,
    required this.controller,
    required this.enabled,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          exercise.prompt,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        if (exercise.hint != null) ...[
          const SizedBox(height: 8),
          Text(
            '💡 ${exercise.hint}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
          ),
        ],
        const SizedBox(height: 24),
        TextField(
          controller: controller,
          enabled: enabled,
          autofocus: false,
          maxLines: 3,
          minLines: 3,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => onSubmitted(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          decoration: const InputDecoration(
            hintText: 'Escribe en inglés…',
          ),
        ),
      ],
    );
  }
}
