/// Utilidades para comparar respuestas del usuario con tolerancia
/// a mayúsculas, acentos, puntuación y errores tipográficos leves.
class TextUtils {
  TextUtils._();

  static const Map<String, String> _accentMap = {
    'á': 'a', 'é': 'e', 'í': 'i', 'ó': 'o', 'ú': 'u', 'ü': 'u', 'ñ': 'n',
  };

  /// Normaliza un texto: minúsculas, sin acentos, sin puntuación,
  /// espacios colapsados.
  static String normalize(String input) {
    var text = input.toLowerCase().trim();
    _accentMap.forEach((k, v) => text = text.replaceAll(k, v));
    text = text.replaceAll(RegExp(r"[^\w\s']"), ' ');
    text = text.replaceAll(RegExp(r"\s+"), ' ').trim();
    // Contracciones comunes en inglés → forma expandida.
    const contractions = {
      "i'm": 'i am',
      "you're": 'you are',
      "he's": 'he is',
      "she's": 'she is',
      "it's": 'it is',
      "we're": 'we are',
      "they're": 'they are',
      "don't": 'do not',
      "doesn't": 'does not',
      "can't": 'cannot',
      "isn't": 'is not',
      "aren't": 'are not',
      "what's": 'what is',
      "where's": 'where is',
      "let's": 'let us',
      "i'd": 'i would',
      "i'll": 'i will',
    };
    contractions.forEach((k, v) => text = text.replaceAll(k, v));
    text = text.replaceAll("'", '');
    return text;
  }

  /// Distancia de Levenshtein entre dos cadenas.
  static int levenshtein(String a, String b) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    var prev = List<int>.generate(b.length + 1, (i) => i);
    var curr = List<int>.filled(b.length + 1, 0);

    for (var i = 0; i < a.length; i++) {
      curr[0] = i + 1;
      for (var j = 0; j < b.length; j++) {
        final cost = a[i] == b[j] ? 0 : 1;
        curr[j + 1] = [
          curr[j] + 1,
          prev[j + 1] + 1,
          prev[j] + cost,
        ].reduce((v, e) => v < e ? v : e);
      }
      final tmp = prev;
      prev = curr;
      curr = tmp;
    }
    return prev[b.length];
  }

  /// Similitud [0..1] entre dos textos ya considerando normalización.
  static double similarity(String a, String b) {
    final na = normalize(a);
    final nb = normalize(b);
    if (na.isEmpty && nb.isEmpty) return 1;
    if (na.isEmpty || nb.isEmpty) return 0;
    final maxLen = na.length > nb.length ? na.length : nb.length;
    return 1 - levenshtein(na, nb) / maxLen;
  }

  /// Resultado de evaluar una respuesta escrita.
  static AnswerCheck checkWritten(String userAnswer, String expected,
      {List<String> alternatives = const []}) {
    final user = normalize(userAnswer);
    final candidates = [expected, ...alternatives];

    for (final candidate in candidates) {
      if (user == normalize(candidate)) {
        return AnswerCheck(correct: true, almost: false, bestMatch: candidate);
      }
    }
    // Tolerancia a errores tipográficos: 1 error por cada 8 caracteres.
    for (final candidate in candidates) {
      final nc = normalize(candidate);
      final allowed = (nc.length / 8).floor().clamp(1, 3);
      if (levenshtein(user, nc) <= allowed) {
        return AnswerCheck(correct: true, almost: true, bestMatch: candidate);
      }
    }
    return AnswerCheck(correct: false, almost: false, bestMatch: expected);
  }

  /// Evalúa lo reconocido por voz contra la frase objetivo.
  /// Es más permisivo que la escritura (el reconocimiento no es perfecto).
  static AnswerCheck checkSpoken(String transcript, String expected) {
    final sim = similarity(transcript, expected);
    if (sim >= 0.85) {
      return AnswerCheck(correct: true, almost: false, bestMatch: expected);
    }
    if (sim >= 0.65) {
      return AnswerCheck(correct: true, almost: true, bestMatch: expected);
    }
    // También aceptamos si reconoce la mayoría de las palabras clave.
    final expectedWords = normalize(expected).split(' ').toSet();
    final saidWords = normalize(transcript).split(' ').toSet();
    if (expectedWords.isNotEmpty) {
      final hit = expectedWords.intersection(saidWords).length /
          expectedWords.length;
      if (hit >= 0.7) {
        return AnswerCheck(correct: true, almost: true, bestMatch: expected);
      }
    }
    return AnswerCheck(correct: false, almost: false, bestMatch: expected);
  }
}

class AnswerCheck {
  final bool correct;

  /// Correcto pero con pequeños errores (se muestra "¡Casi perfecto!").
  final bool almost;
  final String bestMatch;

  const AnswerCheck({
    required this.correct,
    required this.almost,
    required this.bestMatch,
  });
}
