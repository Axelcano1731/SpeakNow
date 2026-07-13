import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../data/course_data.dart';
import '../../models/models.dart';
import '../../providers/progress_provider.dart';
import '../../widgets/duo_button.dart';
import '../../widgets/mascot.dart';
import '../../widgets/stat_chips.dart';
import '../lesson/lesson_screen.dart';

/// Práctica libre: mezcla ejercicios de las lecciones ya completadas
/// (o de la primera lección si aún no hay progreso) y recupera un corazón.
class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  Lesson _buildPracticeSession(ProgressProvider progress) {
    final random = Random();
    final completed = CourseData.allLessons
        .where((l) => progress.isLessonCompleted(l.id))
        .toList();
    final source = completed.isEmpty
        ? [CourseData.allLessons.first]
        : completed;

    final pool = source.expand((l) => l.exercises).toList()..shuffle(random);
    final exercises = pool.take(8).toList();

    return Lesson(
      id: 'practice',
      title: 'Práctica',
      emoji: '🏋️',
      exercises: exercises,
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final completedCount = progress.completedLessons.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Práctica'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(child: StatChips()),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const Mascot(size: 130),
              const SizedBox(height: 24),
              Text(
                'Sesión de práctica',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              Text(
                completedCount == 0
                    ? 'Practica los ejercicios de tu primera lección para calentar motores.'
                    : 'Repasa ejercicios de las $completedCount lecciones que ya completaste.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.heartRed.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  '💜 Completa la práctica y recupera 1 corazón',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const Spacer(),
              DuoButton(
                label: 'Empezar práctica',
                color: AppColors.brandPurple,
                onPressed: () {
                  final session = _buildPracticeSession(progress);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          LessonScreen(lesson: session, isPractice: true),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
