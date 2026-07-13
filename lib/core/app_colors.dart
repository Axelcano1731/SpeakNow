import 'package:flutter/material.dart';

/// Paleta oficial de SpeakNow English Academy.
class AppColors {
  AppColors._();

  // Marca
  static const Color brandDeep = Color(0xFF4C2882); // morado profundo
  static const Color brandLavender = Color(0xFFB18BD6); // lavanda
  static const Color brandPurple = Color(0xFF800080); // púrpura

  // Modo oscuro
  static const Color darkBackground = Color(0xFF1A1033);
  static const Color darkSurface = Color(0xFF261A45);
  static const Color darkCard = Color(0xFF31235A);

  // Modo claro
  static const Color lightBackground = Color(0xFFFAF7FF);
  static const Color lightSurface = Colors.white;
  static const Color lightCard = Color(0xFFF3EDFB);

  // Estados (feedback de ejercicios)
  static const Color success = Color(0xFF2EC46D);
  static const Color successDark = Color(0xFF1E9A52);
  static const Color error = Color(0xFFE74C4C);
  static const Color errorDark = Color(0xFFB93A3A);
  static const Color warning = Color(0xFFFFB020);

  // Gamificación
  static const Color streakFlame = Color(0xFFFF9600);
  static const Color xpGold = Color(0xFFFFC800);
  static const Color heartRed = Color(0xFFFF4B6E);

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandDeep, brandPurple],
  );

  static const LinearGradient lavenderGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [brandLavender, brandDeep],
  );
}
