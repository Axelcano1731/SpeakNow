import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../widgets/duo_button.dart';
import '../../widgets/mascot.dart';

/// Pantalla de celebración al terminar una lección o práctica.
class LessonCompleteScreen extends StatefulWidget {
  final int xpEarned;
  final bool perfect;
  final int mistakes;
  final bool isPractice;

  const LessonCompleteScreen({
    super.key,
    required this.xpEarned,
    required this.perfect,
    required this.mistakes,
    this.isPractice = false,
  });

  @override
  State<LessonCompleteScreen> createState() => _LessonCompleteScreenState();
}

class _LessonCompleteScreenState extends State<LessonCompleteScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String title;
    final String subtitle;
    if (widget.isPractice) {
      title = '¡Buena práctica!';
      subtitle = 'Recuperaste 1 corazón 💜';
    } else if (widget.perfect) {
      title = '¡Lección perfecta!';
      subtitle = 'Sin ningún error. ¡Increíble!';
    } else {
      title = '¡Lección completada!';
      subtitle = widget.mistakes == 1
          ? 'Solo 1 error. ¡Muy bien!'
          : '${widget.mistakes} errores. ¡Sigue así!';
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.brandGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                ScaleTransition(
                  scale: CurvedAnimation(
                    parent: _controller,
                    curve: Curves.elasticOut,
                  ),
                  child: const Mascot(size: 150),
                ),
                const SizedBox(height: 28),
                FadeTransition(
                  opacity: _controller,
                  child: Column(
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _StatBox(
                            label: 'XP GANADO',
                            value: '+${widget.xpEarned}',
                            emoji: '⭐',
                          ),
                          if (widget.perfect) ...[
                            const SizedBox(width: 16),
                            const _StatBox(
                              label: 'PRECISIÓN',
                              value: '100%',
                              emoji: '🎯',
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                DuoButton(
                  label: 'Continuar',
                  color: Colors.white,
                  shadowColor: AppColors.brandLavender,
                  textColor: AppColors.brandDeep,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final String emoji;

  const _StatBox({
    required this.label,
    required this.value,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.4),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$emoji $value',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
