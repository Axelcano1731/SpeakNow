import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Servicio de reconocimiento de voz para los ejercicios de habla.
///
/// En plataformas sin soporte (p. ej. Windows escritorio) `isAvailable`
/// queda en falso y la UI ofrece omitir el ejercicio.
class SpeechService {
  SpeechService._();
  static final SpeechService instance = SpeechService._();

  final SpeechToText _speech = SpeechToText();
  bool _initialized = false;
  bool _available = false;

  bool get isAvailable => _available;
  bool get isListening => _speech.isListening;

  Future<bool> init() async {
    if (_initialized) return _available;
    _initialized = true;
    try {
      _available = await _speech.initialize(
        onError: (_) {},
        onStatus: (_) {},
      );
    } catch (_) {
      _available = false;
    }
    return _available;
  }

  /// Escucha en inglés y entrega el texto parcial/final reconocido.
  Future<void> listen({
    required void Function(String text, bool isFinal) onResult,
  }) async {
    final ok = await init();
    if (!ok) return;
    await _speech.listen(
      listenOptions: SpeechListenOptions(
        localeId: 'en_US',
        listenFor: const Duration(seconds: 12),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        cancelOnError: true,
      ),
      onResult: (SpeechRecognitionResult result) {
        onResult(result.recognizedWords, result.finalResult);
      },
    );
  }

  Future<void> stop() async {
    try {
      await _speech.stop();
    } catch (_) {}
  }

  Future<void> cancel() async {
    try {
      await _speech.cancel();
    } catch (_) {}
  }
}
