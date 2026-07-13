import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../data/course_data.dart';
import '../../models/models.dart';
import '../../providers/progress_provider.dart';
import '../../widgets/stat_chips.dart';
import '../lesson/lesson_screen.dart';

/// Ruta de aprendizaje: camino serpenteante de lecciones por unidad,
/// al estilo Duolingo.
class LearningPathScreen extends StatelessWidget {
  const LearningPathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('SpeakNow'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(child: StatChips()),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          for (final unit in CourseData.units) ...[
            _UnitHeader(unit: unit),
            _UnitPath(unit: unit, progress: progress),
          ],
        ],
      ),
    );
  }
}

class _UnitHeader extends StatelessWidget {
  final Unit unit;

  const _UnitHeader({required this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [unit.color, Color.alphaBlend(
            Colors.black.withValues(alpha: 0.25), unit.color)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            unit.title.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w800,
              fontSize: 13,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            unit.subtitle,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _UnitPath extends StatelessWidget {
  final Unit unit;
  final ProgressProvider progress;

  const _UnitPath({required this.unit, required this.progress});

  @override
  Widget build(BuildContext context) {
    // Desplazamientos horizontales para el efecto serpenteante.
    const offsets = [0.0, -70.0, 70.0, -40.0, 40.0];

    return Column(
      children: [
        for (var i = 0; i < unit.lessons.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Transform.translate(
              offset: Offset(offsets[i % offsets.length], 0),
              child: _LessonNode(
                lesson: unit.lessons[i],
                unitColor: unit.color,
                completed: progress.isLessonCompleted(unit.lessons[i].id),
                unlocked: progress.isLessonUnlocked(unit.lessons[i].id),
              ),
            ),
          ),
      ],
    );
  }
}

class _LessonNode extends StatelessWidget {
  final Lesson lesson;
  final Color unitColor;
  final bool completed;
  final bool unlocked;

  const _LessonNode({
    required this.lesson,
    required this.unitColor,
    required this.completed,
    required this.unlocked,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final Color bg;
    final Widget inner;
    if (completed) {
      bg = AppColors.xpGold;
      inner = const Icon(Icons.check_rounded, color: Colors.white, size: 36);
    } else if (unlocked) {
      bg = unitColor;
      inner = Text(lesson.emoji, style: const TextStyle(fontSize: 30));
    } else {
      bg = scheme.surfaceContainerHighest;
      inner = Icon(Icons.lock_rounded,
          color: scheme.onSurface.withValues(alpha: 0.35), size: 30);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: unlocked
              ? () {
                  final progress = context.read<ProgressProvider>();
                  if (progress.hearts <= 0 && !completed) {
                    _showNoHeartsDialog(context);
                    return;
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => LessonScreen(lesson: lesson),
                    ),
                  );
                }
              : () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          '🔒 Completa la lección anterior para desbloquear'),
                    ),
                  ),
          child: Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: unlocked
                      ? Color.alphaBlend(
                          Colors.black.withValues(alpha: 0.3), bg)
                      : scheme.outline,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(child: inner),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          lesson.title,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 13,
            color: unlocked
                ? scheme.onSurface
                : scheme.onSurface.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }

  void _showNoHeartsDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('💔 Sin corazones'),
        content: const Text(
          'Te quedaste sin corazones. Espera a que se recarguen '
          'o haz una sesión de práctica para recuperarlos.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}
