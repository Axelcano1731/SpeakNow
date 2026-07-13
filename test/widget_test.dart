import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:speaknow/core/text_utils.dart';
import 'package:speaknow/data/course_data.dart';
import 'package:speaknow/main.dart';
import 'package:speaknow/models/models.dart';
import 'package:speaknow/providers/lesson_controller.dart';

void main() {
  group('TextUtils', () {
    test('acepta respuesta exacta ignorando mayúsculas y puntuación', () {
      final check = TextUtils.checkWritten('good morning!', 'Good morning');
      expect(check.correct, isTrue);
      expect(check.almost, isFalse);
    });

    test('acepta errores tipográficos leves como "casi correcto"', () {
      final check = TextUtils.checkWritten('Good mornng', 'Good morning');
      expect(check.correct, isTrue);
      expect(check.almost, isTrue);
    });

    test('rechaza respuestas incorrectas', () {
      final check = TextUtils.checkWritten('Good night', 'Good morning');
      expect(check.correct, isFalse);
    });

    test('acepta alternativas válidas', () {
      final check = TextUtils.checkWritten(
        "I'm Ana",
        'My name is Ana',
        alternatives: ["I'm Ana", 'I am Ana'],
      );
      expect(check.correct, isTrue);
    });

    test('expande contracciones en inglés', () {
      expect(TextUtils.normalize("I'm fine"), TextUtils.normalize('I am fine'));
    });

    test('evalúa habla con tolerancia', () {
      final check =
          TextUtils.checkSpoken('hello good morning', 'Hello, good morning!');
      expect(check.correct, isTrue);
    });
  });

  group('CourseData', () {
    test('todas las lecciones tienen ejercicios', () {
      for (final lesson in CourseData.allLessons) {
        expect(lesson.exercises, isNotEmpty,
            reason: 'La lección ${lesson.id} no tiene ejercicios');
      }
    });

    test('los ejercicios de cartas incluyen la respuesta entre las opciones',
        () {
      for (final lesson in CourseData.allLessons) {
        for (final exercise in lesson.exercises) {
          if (exercise.type == ExerciseType.selectCard ||
              exercise.type == ExerciseType.listen) {
            expect(
              exercise.options.map((o) => o.text).contains(exercise.answer),
              isTrue,
              reason:
                  'En ${lesson.id}, la respuesta "${exercise.answer}" no está entre las cartas',
            );
          }
        }
      }
    });

    test('los ids de lección son únicos', () {
      final ids = CourseData.allLessons.map((l) => l.id).toList();
      expect(ids.toSet().length, ids.length);
    });
  });

  group('LessonController', () {
    Exercise ex(String answer) => Exercise(
          type: ExerciseType.selectCard,
          prompt: '¿?',
          answer: answer,
          options: [CardOption(answer), const CardOption('otra')],
        );

    test('re-encola los ejercicios fallados', () {
      final controller = LessonController(exercises: [ex('a'), ex('b')]);

      controller.submitAnswer('mal'); // falla el primero
      expect(controller.phase, LessonPhase.checkedWrong);
      controller.next();

      controller.submitAnswer('b'); // acierta el segundo
      controller.next();

      // El primero vuelve a aparecer.
      expect(controller.current.answer, 'a');
      controller.submitAnswer('a');
      controller.next();
      expect(controller.isFinished, isTrue);
      expect(controller.mistakes, 1);
      expect(controller.isPerfect, isFalse);
    });

    test('lección perfecta sin errores', () {
      final controller = LessonController(exercises: [ex('a')]);
      controller.submitAnswer('a');
      controller.next();
      expect(controller.isFinished, isTrue);
      expect(controller.isPerfect, isTrue);
    });
  });

  testWidgets('la app arranca mostrando el splash y navega al onboarding',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const SpeakNowApp());
    expect(find.text('SpeakNow'), findsOneWidget);
    expect(find.text('ENGLISH ACADEMY'), findsOneWidget);

    // Deja que el temporizador del splash termine y navegue.
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Aprende con cartas'), findsOneWidget);
  });
}
