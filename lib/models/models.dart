import 'package:flutter/material.dart';

/// Tipos de ejercicio soportados por el motor de lecciones.
enum ExerciseType {
  /// Selecciona la carta correcta a partir de una pregunta.
  selectCard,

  /// Escucha el audio (TTS) y selecciona lo que oíste.
  listen,

  /// Pronuncia la frase; se evalúa con reconocimiento de voz.
  speak,

  /// Escribe la traducción; se corrige con tolerancia a errores.
  write,
}

/// Una opción tipo "carta" para los ejercicios de selección.
class CardOption {
  final String text;
  final String emoji;

  const CardOption(this.text, {this.emoji = ''});
}

class Exercise {
  final ExerciseType type;

  /// Instrucción o pregunta mostrada al usuario.
  final String prompt;

  /// Frase que reproduce el TTS (ejercicios de escucha y habla).
  final String? audioText;

  /// Respuesta correcta.
  final String answer;

  /// Respuestas alternativas también válidas (escritura).
  final List<String> alternatives;

  /// Cartas a mostrar (selección / escucha).
  final List<CardOption> options;

  /// Pista opcional.
  final String? hint;

  const Exercise({
    required this.type,
    required this.prompt,
    required this.answer,
    this.audioText,
    this.alternatives = const [],
    this.options = const [],
    this.hint,
  });
}

class Lesson {
  final String id;
  final String title;
  final String emoji;
  final List<Exercise> exercises;

  const Lesson({
    required this.id,
    required this.title,
    required this.emoji,
    required this.exercises,
  });
}

class Unit {
  final String id;
  final String title;
  final String subtitle;
  final Color color;
  final List<Lesson> lessons;

  const Unit({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.lessons,
  });
}
