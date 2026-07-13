import 'package:flutter/material.dart';

import '../core/app_colors.dart';

/// Mascota de SpeakNow (el panda del logo).
///
/// Usa `assets/images/logo.png` si existe; si no, muestra un panda
/// de respaldo con el estilo de la marca para que la app nunca se rompa.
class Mascot extends StatelessWidget {
  final double size;
  final bool circleBackground;

  const Mascot({super.key, this.size = 120, this.circleBackground = true});

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: circleBackground ? AppColors.lavenderGradient : null,
        border: Border.all(color: AppColors.brandLavender, width: 3),
      ),
      alignment: Alignment.center,
      child: Text('🐼', style: TextStyle(fontSize: size * 0.5)),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: Image.asset(
        'assets/images/logo.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback,
      ),
    );
  }
}
