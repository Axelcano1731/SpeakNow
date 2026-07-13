import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../providers/progress_provider.dart';

/// Fila de estadísticas (racha, XP, corazones) para la barra superior.
class StatChips extends StatelessWidget {
  const StatChips({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _chip('🔥', '${progress.streak}', AppColors.streakFlame),
        const SizedBox(width: 10),
        _chip('⭐', '${progress.xp}', AppColors.xpGold),
        const SizedBox(width: 10),
        _chip('💜', '${progress.hearts}', AppColors.heartRed),
      ],
    );
  }

  Widget _chip(String emoji, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
