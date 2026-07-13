import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../data/course_data.dart';
import '../../providers/progress_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/mascot.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final scheme = Theme.of(context).colorScheme;
    final totalLessons = CourseData.allLessons.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Cabecera de usuario
          Row(
            children: [
              const Mascot(size: 80),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      progress.userName.isEmpty
                          ? 'Estudiante'
                          : progress.userName,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Aprendiendo inglés 🇺🇸',
                      style: TextStyle(
                        color: scheme.onSurface.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Progreso del curso
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.brandGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PROGRESO DEL CURSO',
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress.courseProgress,
                    minHeight: 12,
                    backgroundColor: Colors.white.withValues(alpha: 0.25),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.xpGold),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${progress.completedLessons.length} de $totalLessons lecciones completadas',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Estadísticas
          Text(
            'Estadísticas',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  emoji: '🔥',
                  value: '${progress.streak}',
                  label: 'Días de racha',
                  color: AppColors.streakFlame,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  emoji: '⭐',
                  value: '${progress.xp}',
                  label: 'XP total',
                  color: AppColors.xpGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  emoji: '💜',
                  value: '${progress.hearts}/${ProgressProvider.maxHearts}',
                  label: 'Corazones',
                  color: AppColors.heartRed,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  emoji: '🏆',
                  value: '${progress.completedLessons.length}',
                  label: 'Lecciones',
                  color: AppColors.brandLavender,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Ajustes
          Text(
            'Ajustes',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Modo oscuro',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  secondary: const Text('🌙', style: TextStyle(fontSize: 22)),
                  value: themeProvider.mode == ThemeMode.dark ||
                      (themeProvider.mode == ThemeMode.system &&
                          MediaQuery.platformBrightnessOf(context) ==
                              Brightness.dark),
                  onChanged: (dark) => themeProvider
                      .setMode(dark ? ThemeMode.dark : ThemeMode.light),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Text('🔄', style: TextStyle(fontSize: 22)),
                  title: const Text('Reiniciar progreso',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  onTap: () => _confirmReset(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'SpeakNow English Academy · MVP 1.0',
              style: TextStyle(
                color: scheme.onSurface.withValues(alpha: 0.4),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('¿Reiniciar progreso?'),
        content: const Text(
            'Se borrarán tu XP, racha y lecciones completadas. '
            'Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<ProgressProvider>().resetAll();
              Navigator.pop(dialogContext);
            },
            child: const Text('Reiniciar',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.emoji,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outline, width: 1.5),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 26)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
