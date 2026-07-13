import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/text_utils.dart';
import '../widgets/duo_button.dart';

/// Panel inferior de retroalimentación tras verificar una respuesta,
/// al estilo Duolingo (verde correcto / rojo incorrecto).
class FeedbackBanner extends StatelessWidget {
  final AnswerCheck check;
  final VoidCallback onContinue;

  const FeedbackBanner({
    super.key,
    required this.check,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final correct = check.correct;
    final color = correct ? AppColors.success : AppColors.error;
    final bg = Theme.of(context).brightness == Brightness.dark
        ? Color.alphaBlend(color.withValues(alpha: 0.18), AppColors.darkSurface)
        : Color.alphaBlend(color.withValues(alpha: 0.12), Colors.white);

    final String title;
    if (!correct) {
      title = 'Incorrecto';
    } else if (check.almost) {
      title = '¡Casi perfecto!';
    } else {
      title = '¡Excelente!';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle),
                  child: Icon(
                    correct ? Icons.check_rounded : Icons.close_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            if (!correct || check.almost) ...[
              const SizedBox(height: 10),
              Text(
                'Respuesta correcta:',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                check.bestMatch,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
            const SizedBox(height: 16),
            DuoButton(
              label: 'Continuar',
              color: color,
              shadowColor:
                  correct ? AppColors.successDark : AppColors.errorDark,
              onPressed: onContinue,
            ),
          ],
        ),
      ),
    );
  }
}
