import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../core/text_utils.dart';
import '../../models/models.dart';
import '../../providers/lesson_controller.dart';
import '../../providers/progress_provider.dart';
import '../../services/speech_service.dart';
import '../../services/tts_service.dart';
import '../../widgets/duo_button.dart';
import '../../widgets/exercise/listen_exercise.dart';
import '../../widgets/exercise/select_card_exercise.dart';
import '../../widgets/exercise/speak_exercise.dart';
import '../../widgets/exercise/write_exercise.dart';
import '../../widgets/feedback_banner.dart';
import 'lesson_complete_screen.dart';

/// Pantalla de lección: presenta la cola de ejercicios, verifica
/// respuestas y gestiona corazones y progreso.
class LessonScreen extends StatefulWidget {
  final Lesson lesson;

  /// Modo práctica: no marca la lección como completada;
  /// otorga XP fijo y recupera un corazón.
  final bool isPractice;

  const LessonScreen({
    super.key,
    required this.lesson,
    this.isPractice = false,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  late final LessonController _controller;
  final TextEditingController _writeController = TextEditingController();

  String? _selectedOption;
  String _transcript = '';
  bool _speechUnavailable = false;

  /// Identifica la instancia de ejercicio actual para reiniciar
  /// el estado de los widgets al avanzar.
  int _exerciseInstance = 0;

  @override
  void initState() {
    super.initState();
    _controller = LessonController(exercises: widget.lesson.exercises);
    _controller.addListener(_onControllerChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChange);
    _controller.dispose();
    _writeController.dispose();
    TtsService.instance.stop();
    SpeechService.instance.cancel();
    super.dispose();
  }

  void _onControllerChange() {
    if (_controller.isFinished) {
      _finishLesson();
    } else {
      setState(() {});
    }
  }

  void _finishLesson() {
    final progress = context.read<ProgressProvider>();
    final int earned;
    if (widget.isPractice) {
      earned = 10;
      progress.addPracticeXp(earned);
      progress.refillOneHeart();
    } else {
      earned =
          progress.completeLesson(widget.lesson.id, perfect: _controller.isPerfect);
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => LessonCompleteScreen(
          xpEarned: earned,
          perfect: _controller.isPerfect,
          mistakes: _controller.mistakes,
          isPractice: widget.isPractice,
        ),
      ),
    );
  }

  bool get _canCheck {
    final exercise = _controller.current;
    return switch (exercise.type) {
      ExerciseType.selectCard || ExerciseType.listen => _selectedOption != null,
      ExerciseType.write => _writeController.text.trim().isNotEmpty,
      ExerciseType.speak => _transcript.trim().isNotEmpty,
    };
  }

  void _check() {
    final exercise = _controller.current;
    final AnswerCheck check;
    switch (exercise.type) {
      case ExerciseType.selectCard:
      case ExerciseType.listen:
        check = AnswerCheck(
          correct: _selectedOption == exercise.answer,
          almost: false,
          bestMatch: exercise.answer,
        );
      case ExerciseType.write:
        check = TextUtils.checkWritten(
          _writeController.text,
          exercise.answer,
          alternatives: exercise.alternatives,
        );
      case ExerciseType.speak:
        check = TextUtils.checkSpoken(_transcript, exercise.answer);
    }

    if (!check.correct && !widget.isPractice) {
      final progress = context.read<ProgressProvider>();
      progress.loseHeart();
      if (progress.hearts <= 0) {
        _controller.submitResult(check);
        _showOutOfHearts();
        return;
      }
    }
    _controller.submitResult(check);
  }

  void _continue() {
    setState(() {
      _selectedOption = null;
      _transcript = '';
      _speechUnavailable = false;
      _writeController.clear();
      _exerciseInstance++;
    });
    _controller.next();
  }

  void _showOutOfHearts() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('💔 ¡Sin corazones!'),
        content: const Text(
          'Te quedaste sin corazones. Practica para recuperarlos '
          'y vuelve a intentar la lección.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            child: const Text('Salir de la lección'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmExit() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('¿Salir de la lección?'),
        content: const Text('Perderás el progreso de esta lección.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Seguir aprendiendo'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Salir',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (leave == true && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final exercise = _controller.current;
    final answering = _controller.phase == LessonPhase.answering;
    final checked = _controller.phase == LessonPhase.checkedCorrect ||
        _controller.phase == LessonPhase.checkedWrong;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmExit();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: _confirmExit,
          ),
          title: _ProgressBar(value: _controller.progress),
          actions: [
            if (!widget.isPractice)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: [
                    const Text('💜', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 4),
                    Text(
                      '${progress.hearts}',
                      style: const TextStyle(
                        color: AppColors.heartRed,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: _buildExercise(exercise, answering),
                ),
              ),
              if (checked && _controller.lastCheck != null)
                FeedbackBanner(
                  check: _controller.lastCheck!,
                  onContinue: _continue,
                )
              else
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (exercise.type == ExerciseType.speak &&
                          _speechUnavailable)
                        DuoButton(
                          label: 'Omitir ejercicio',
                          color: AppColors.brandLavender,
                          onPressed: () {
                            _controller.skip();
                          },
                        )
                      else
                        DuoButton(
                          label: 'Comprobar',
                          color: AppColors.success,
                          shadowColor: AppColors.successDark,
                          onPressed: _canCheck ? _check : null,
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExercise(Exercise exercise, bool answering) {
    final key = ValueKey('exercise_$_exerciseInstance');
    final revealed = _controller.phase == LessonPhase.checkedCorrect ||
        _controller.phase == LessonPhase.checkedWrong;

    switch (exercise.type) {
      case ExerciseType.selectCard:
        return SelectCardExercise(
          key: key,
          exercise: exercise,
          selected: _selectedOption,
          enabled: answering,
          revealAnswer: revealed,
          onSelected: (value) => setState(() => _selectedOption = value),
        );
      case ExerciseType.listen:
        return ListenExercise(
          key: key,
          exercise: exercise,
          selected: _selectedOption,
          enabled: answering,
          revealAnswer: revealed,
          onSelected: (value) => setState(() => _selectedOption = value),
        );
      case ExerciseType.write:
        return WriteExercise(
          key: key,
          exercise: exercise,
          controller: _writeController,
          enabled: answering,
          onSubmitted: () {
            if (_canCheck && answering) _check();
          },
        );
      case ExerciseType.speak:
        return SpeakExercise(
          key: key,
          exercise: exercise,
          enabled: answering,
          onTranscript: (text) => setState(() => _transcript = text),
          onUnavailable: () => setState(() => _speechUnavailable = true),
        );
    }
  }
}

class _ProgressBar extends StatelessWidget {
  final double value;

  const _ProgressBar({required this.value});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        builder: (_, animated, _) => LinearProgressIndicator(
          value: animated,
          minHeight: 14,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          valueColor:
              const AlwaysStoppedAnimation<Color>(AppColors.brandLavender),
        ),
      ),
    );
  }
}
