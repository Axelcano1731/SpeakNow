import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../models/models.dart';
import '../../services/speech_service.dart';
import '../../services/tts_service.dart';

/// Ejercicio de habla: el usuario pronuncia la frase y se evalúa
/// con reconocimiento de voz.
class SpeakExercise extends StatefulWidget {
  final Exercise exercise;
  final bool enabled;

  /// Se llama con el texto reconocido (parcial o final).
  final ValueChanged<String> onTranscript;

  /// El micrófono no está disponible → permitir omitir.
  final VoidCallback onUnavailable;

  const SpeakExercise({
    super.key,
    required this.exercise,
    required this.enabled,
    required this.onTranscript,
    required this.onUnavailable,
  });

  @override
  State<SpeakExercise> createState() => _SpeakExerciseState();
}

class _SpeakExerciseState extends State<SpeakExercise>
    with SingleTickerProviderStateMixin {
  bool _listening = false;
  bool _micUnavailable = false;
  String _transcript = '';
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.9,
      upperBound: 1.1,
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    SpeechService.instance.cancel();
    super.dispose();
  }

  Future<void> _toggleMic() async {
    if (_listening) {
      await SpeechService.instance.stop();
      setState(() => _listening = false);
      _pulse.stop();
      return;
    }
    final available = await SpeechService.instance.init();
    if (!available) {
      setState(() => _micUnavailable = true);
      widget.onUnavailable();
      return;
    }
    setState(() {
      _listening = true;
      _transcript = '';
    });
    _pulse.repeat(reverse: true);
    await SpeechService.instance.listen(
      onResult: (text, isFinal) {
        if (!mounted) return;
        setState(() => _transcript = text);
        widget.onTranscript(text);
        if (isFinal) {
          setState(() => _listening = false);
          _pulse.stop();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.exercise.prompt,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 24),
        // Tarjeta con la frase a pronunciar + botón para oírla.
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: scheme.outline, width: 2),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () =>
                    TtsService.instance.speak(widget.exercise.audioText ??
                        widget.exercise.answer),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    gradient: AppColors.brandGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.volume_up_rounded,
                      color: Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.exercise.audioText ?? widget.exercise.answer,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        // Micrófono
        Center(
          child: Column(
            children: [
              ScaleTransition(
                scale: _pulse,
                child: GestureDetector(
                  onTap: widget.enabled ? _toggleMic : null,
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      gradient: _listening
                          ? const LinearGradient(
                              colors: [AppColors.error, AppColors.heartRed])
                          : AppColors.brandGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (_listening
                                  ? AppColors.error
                                  : AppColors.brandDeep)
                              .withValues(alpha: 0.4),
                          blurRadius: 20,
                          spreadRadius: _listening ? 6 : 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      _listening ? Icons.stop_rounded : Icons.mic_rounded,
                      color: Colors.white,
                      size: 44,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _listening
                    ? 'Escuchando… habla ahora'
                    : 'Toca el micrófono y habla',
                style: TextStyle(
                  color: scheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Transcripción en vivo
        if (_transcript.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.brandLavender.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '🎙️ "$_transcript"',
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        if (_micUnavailable)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              'El micrófono no está disponible en este dispositivo. '
              'Puedes omitir este ejercicio.',
              style: TextStyle(
                color: AppColors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
