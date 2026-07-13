import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../models/models.dart';
import '../../services/tts_service.dart';
import 'select_card_exercise.dart';

/// Ejercicio de escucha: reproduce la frase con TTS y el usuario
/// selecciona la carta correcta.
class ListenExercise extends StatefulWidget {
  final Exercise exercise;
  final String? selected;
  final bool enabled;
  final ValueChanged<String> onSelected;
  final bool revealAnswer;

  const ListenExercise({
    super.key,
    required this.exercise,
    required this.selected,
    required this.enabled,
    required this.onSelected,
    this.revealAnswer = false,
  });

  @override
  State<ListenExercise> createState() => _ListenExerciseState();
}

class _ListenExerciseState extends State<ListenExercise> {
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    // Reproduce automáticamente al entrar al ejercicio.
    WidgetsBinding.instance.addPostFrameCallback((_) => _play());
  }

  Future<void> _play({bool slow = false}) async {
    final text = widget.exercise.audioText;
    if (text == null) return;
    setState(() => _playing = true);
    await TtsService.instance.speak(text, slow: slow);
    if (mounted) setState(() => _playing = false);
  }

  @override
  Widget build(BuildContext context) {
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
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _AudioButton(
              icon: Icons.volume_up_rounded,
              size: 72,
              active: _playing,
              onTap: () => _play(),
            ),
            const SizedBox(width: 16),
            _AudioButton(
              icon: Icons.slow_motion_video_rounded,
              size: 52,
              active: false,
              onTap: () => _play(slow: true),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: SelectCardExercise(
            exercise: widget.exercise.copyWithoutPrompt(),
            selected: widget.selected,
            enabled: widget.enabled,
            onSelected: widget.onSelected,
            revealAnswer: widget.revealAnswer,
          ),
        ),
      ],
    );
  }
}

extension on Exercise {
  /// Variante sin texto de pregunta para no duplicarla en pantalla.
  Exercise copyWithoutPrompt() => Exercise(
        type: type,
        prompt: '',
        answer: answer,
        audioText: audioText,
        alternatives: alternatives,
        options: options,
        hint: hint,
      );
}

class _AudioButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final bool active;
  final VoidCallback onTap;

  const _AudioButton({
    required this.icon,
    required this.size,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: AppColors.brandGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.brandDeep.withValues(alpha: 0.45),
              blurRadius: active ? 18 : 8,
              spreadRadius: active ? 4 : 1,
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.5),
      ),
    );
  }
}
