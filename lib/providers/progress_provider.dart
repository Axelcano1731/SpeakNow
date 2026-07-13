import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/course_data.dart';

/// Progreso global del usuario: XP, racha, corazones y lecciones completadas.
/// Se persiste en el dispositivo con SharedPreferences.
class ProgressProvider extends ChangeNotifier {
  static const int maxHearts = 5;
  static const Duration heartRefill = Duration(minutes: 30);

  SharedPreferences? _prefs;

  int _xp = 0;
  int _streak = 0;
  int _hearts = maxHearts;
  DateTime? _lastSessionDate;
  DateTime? _lastHeartLoss;
  Set<String> _completedLessons = {};
  bool _onboardingDone = false;
  String _userName = '';
  bool _loaded = false;

  int get xp => _xp;
  int get streak => _streak;
  int get hearts => _hearts;
  Set<String> get completedLessons => _completedLessons;
  bool get onboardingDone => _onboardingDone;
  String get userName => _userName;
  bool get loaded => _loaded;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    final p = _prefs!;
    _xp = p.getInt('xp') ?? 0;
    _streak = p.getInt('streak') ?? 0;
    _hearts = p.getInt('hearts') ?? maxHearts;
    _onboardingDone = p.getBool('onboardingDone') ?? false;
    _userName = p.getString('userName') ?? '';
    _completedLessons = (p.getStringList('completedLessons') ?? []).toSet();
    final last = p.getString('lastSessionDate');
    _lastSessionDate = last != null ? DateTime.tryParse(last) : null;
    final lastLoss = p.getString('lastHeartLoss');
    _lastHeartLoss = lastLoss != null ? DateTime.tryParse(lastLoss) : null;

    _checkStreakExpiry();
    _refillHeartsOverTime();
    _loaded = true;
    notifyListeners();
  }

  Future<void> _save() async {
    final p = _prefs;
    if (p == null) return;
    await p.setInt('xp', _xp);
    await p.setInt('streak', _streak);
    await p.setInt('hearts', _hearts);
    await p.setBool('onboardingDone', _onboardingDone);
    await p.setString('userName', _userName);
    await p.setStringList('completedLessons', _completedLessons.toList());
    if (_lastSessionDate != null) {
      await p.setString(
          'lastSessionDate', _lastSessionDate!.toIso8601String());
    }
    if (_lastHeartLoss != null) {
      await p.setString('lastHeartLoss', _lastHeartLoss!.toIso8601String());
    }
  }

  // ------------------------------------------------------------------ Racha
  /// Si el usuario dejó pasar más de un día completo, la racha se rompe.
  void _checkStreakExpiry() {
    if (_lastSessionDate == null) return;
    final today = _dateOnly(DateTime.now());
    final last = _dateOnly(_lastSessionDate!);
    if (today.difference(last).inDays > 1) {
      _streak = 0;
    }
  }

  /// Marca actividad de hoy y extiende la racha si corresponde.
  void _registerActivity() {
    final today = _dateOnly(DateTime.now());
    if (_lastSessionDate == null) {
      _streak = 1;
    } else {
      final last = _dateOnly(_lastSessionDate!);
      final diff = today.difference(last).inDays;
      if (diff == 1) {
        _streak += 1;
      } else if (diff > 1) {
        _streak = 1;
      } else if (_streak == 0) {
        _streak = 1;
      }
    }
    _lastSessionDate = DateTime.now();
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  // -------------------------------------------------------------- Corazones
  void _refillHeartsOverTime() {
    if (_hearts >= maxHearts || _lastHeartLoss == null) return;
    final elapsed = DateTime.now().difference(_lastHeartLoss!);
    final regained = elapsed.inMinutes ~/ heartRefill.inMinutes;
    if (regained > 0) {
      _hearts = (_hearts + regained).clamp(0, maxHearts);
      _lastHeartLoss = _hearts < maxHearts ? DateTime.now() : null;
    }
  }

  /// Pierde un corazón. Devuelve false si ya no quedaban.
  bool loseHeart() {
    _refillHeartsOverTime();
    if (_hearts <= 0) return false;
    _hearts -= 1;
    _lastHeartLoss ??= DateTime.now();
    _save();
    notifyListeners();
    return true;
  }

  void refillHearts() {
    _hearts = maxHearts;
    _lastHeartLoss = null;
    _save();
    notifyListeners();
  }

  /// Recupera un corazón (recompensa por practicar).
  void refillOneHeart() {
    if (_hearts >= maxHearts) return;
    _hearts += 1;
    if (_hearts >= maxHearts) _lastHeartLoss = null;
    _save();
    notifyListeners();
  }

  // ------------------------------------------------------------------ Lecciones
  bool isLessonCompleted(String lessonId) =>
      _completedLessons.contains(lessonId);

  /// Una lección está desbloqueada si es la primera o la anterior
  /// (en el orden del curso) ya fue completada.
  bool isLessonUnlocked(String lessonId) {
    final all = CourseData.allLessons;
    final index = all.indexWhere((l) => l.id == lessonId);
    if (index <= 0) return true;
    return _completedLessons.contains(all[index - 1].id);
  }

  /// Registra la lección terminada y suma XP. Devuelve el XP ganado.
  int completeLesson(String lessonId, {required bool perfect}) {
    final isNew = !_completedLessons.contains(lessonId);
    _completedLessons.add(lessonId);
    var earned = isNew ? 20 : 10;
    if (perfect) earned += 5;
    _xp += earned;
    _registerActivity();
    _save();
    notifyListeners();
    return earned;
  }

  void addPracticeXp(int amount) {
    _xp += amount;
    _registerActivity();
    _save();
    notifyListeners();
  }

  // ------------------------------------------------------------------ Otros
  Future<void> finishOnboarding(String name) async {
    _onboardingDone = true;
    _userName = name.trim();
    await _save();
    notifyListeners();
  }

  Future<void> resetAll() async {
    _xp = 0;
    _streak = 0;
    _hearts = maxHearts;
    _completedLessons = {};
    _lastSessionDate = null;
    _lastHeartLoss = null;
    await _save();
    notifyListeners();
  }

  /// Porcentaje de avance del curso completo [0..1].
  double get courseProgress {
    final total = CourseData.allLessons.length;
    if (total == 0) return 0;
    return _completedLessons.length / total;
  }
}
