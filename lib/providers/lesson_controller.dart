import 'package:flutter/foundation.dart';

import '../core/text_utils.dart';
import '../models/models.dart';

enum LessonPhase { answering, checkedCorrect, checkedWrong, finished }

/// Controla el flujo de una lección: cola de ejercicios, verificación
/// de respuestas y re-encolado de los fallados (estilo Duolingo).
class LessonController extends ChangeNotifier {
  LessonController({required List<Exercise> exercises})
      : _queue = List.of(exercises),
        _initialCount = exercises.length;

  final List<Exercise> _queue;
  final int _initialCount;

  int _index = 0;
  int _mistakes = 0;
  int _answeredCorrectly = 0;
  LessonPhase _phase = LessonPhase.answering;

  /// Feedback de la última verificación.
  AnswerCheck? lastCheck;

  Exercise get current => _queue[_index];
  LessonPhase get phase => _phase;
  int get mistakes => _mistakes;
  bool get isPerfect => _mistakes == 0;

  /// Progreso visual [0..1]: ejercicios respondidos bien sobre el total.
  double get progress =>
      _initialCount == 0 ? 1 : _answeredCorrectly / _initialCount;

  bool get isFinished => _phase == LessonPhase.finished;

  /// Verifica una respuesta ya evaluada por el widget del ejercicio.
  void submitResult(AnswerCheck check) {
    lastCheck = check;
    if (check.correct) {
      _answeredCorrectly++;
      _phase = LessonPhase.checkedCorrect;
    } else {
      _mistakes++;
      // El ejercicio fallado vuelve al final de la cola.
      _queue.add(current);
      _phase = LessonPhase.checkedWrong;
    }
    notifyListeners();
  }

  /// Verifica respuestas de texto (selección de carta / escucha).
  void submitAnswer(String userAnswer) {
    final exercise = current;
    final normalizedUser = TextUtils.normalize(userAnswer);
    final correct =
        normalizedUser == TextUtils.normalize(exercise.answer);
    submitResult(AnswerCheck(
      correct: correct,
      almost: false,
      bestMatch: exercise.answer,
    ));
  }

  /// Avanza al siguiente ejercicio o termina la lección.
  void next() {
    if (_index + 1 < _queue.length) {
      _index++;
      _phase = LessonPhase.answering;
      lastCheck = null;
    } else {
      _phase = LessonPhase.finished;
    }
    notifyListeners();
  }

  /// Salta el ejercicio actual (p. ej. hablar sin micrófono disponible).
  void skip() {
    _answeredCorrectly++;
    _phase = LessonPhase.checkedCorrect;
    lastCheck = AnswerCheck(
      correct: true,
      almost: false,
      bestMatch: current.answer,
    );
    notifyListeners();
  }
}
