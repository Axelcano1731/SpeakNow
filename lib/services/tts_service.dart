import 'package:flutter_tts/flutter_tts.dart';

/// Servicio de texto a voz para los ejercicios de escucha.
class TtsService {
  TtsService._();
  static final TtsService instance = TtsService._();

  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.45);
      await _tts.setPitch(1.0);
      await _tts.awaitSpeakCompletion(true);
      _initialized = true;
    } catch (_) {
      // Si TTS no está disponible en la plataforma, la app sigue funcionando.
    }
  }

  /// Reproduce [text] en inglés. [slow] baja la velocidad (botón tortuga).
  Future<void> speak(String text, {bool slow = false}) async {
    await _init();
    try {
      await _tts.stop();
      await _tts.setSpeechRate(slow ? 0.25 : 0.45);
      await _tts.speak(text);
    } catch (_) {
      // Silencioso: no rompemos el flujo de la lección.
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
