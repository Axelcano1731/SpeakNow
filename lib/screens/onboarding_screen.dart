import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../providers/progress_provider.dart';
import '../widgets/duo_button.dart';
import '../widgets/mascot.dart';
import 'main_shell.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  int _page = 0;

  static const _pages = [
    (
      emoji: '🃏',
      title: 'Aprende con cartas',
      body:
          'Responde preguntas eligiendo la carta correcta. Cada lección es un juego.',
    ),
    (
      emoji: '🎙️',
      title: 'Habla y escucha',
      body:
          'Practica tu pronunciación con reconocimiento de voz y entrena tu oído con audios en inglés.',
    ),
    (
      emoji: '🔥',
      title: 'Mantén tu racha',
      body:
          'Gana XP, cuida tus corazones y practica todos los días para no perder tu racha.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < _pages.length) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _start() async {
    final name = _nameController.text.trim();
    await context
        .read<ProgressProvider>()
        .finishOnboarding(name.isEmpty ? 'Estudiante' : name);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final totalPages = _pages.length + 1; // +1 página de nombre

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Mascot(size: 110),
            const SizedBox(height: 8),
            Text(
              'SpeakNow',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.brandLavender
                    : AppColors.brandDeep,
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _page = i),
                children: [
                  for (final page in _pages)
                    _OnboardingPage(
                      emoji: page.emoji,
                      title: page.title,
                      body: page.body,
                    ),
                  _NamePage(controller: _nameController),
                ],
              ),
            ),
            // Indicadores de página
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < totalPages; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _page == i ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _page == i
                          ? AppColors.brandLavender
                          : scheme.outline,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: DuoButton(
                label: _page == totalPages - 1 ? '¡Empezar!' : 'Siguiente',
                color: AppColors.brandDeep,
                onPressed: _page == totalPages - 1 ? _start : _next,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String emoji;
  final String title;
  final String body;

  const _OnboardingPage({
    required this.emoji,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 80)),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          Text(
            body,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}

class _NamePage extends StatelessWidget {
  final TextEditingController controller;

  const _NamePage({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('✏️', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 24),
          Text(
            '¿Cómo te llamas?',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controller,
            textAlign: TextAlign.center,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            decoration: const InputDecoration(hintText: 'Tu nombre'),
          ),
        ],
      ),
    );
  }
}
