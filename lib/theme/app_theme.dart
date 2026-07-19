import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Shared ──
  static const Color secondary = Color(0xFFC5A850);     // Angora Accent Gold
  static const Color accentBlue = Color(0xFF50B4FC);     // Heterochromia blue

  // ── Day Theme (06:00 - 17:59) ──
  static const Color dayPrimary = Color(0xFF0A3981);     // Royal Blue
  static const Color dayScaffold = Color(0xFFF8FAFC);
  static const Color daySurface = Color(0xFFFFFFFF);
  static const Color dayCard = Color(0xFFFFFFFF);
  static const Color dayTextPrimary = Color(0xFF0A3981);
  static const Color dayTextMuted = Color(0xFF475569);
  static const Color dayTextDim = Color(0xFF94A3B8);
  static const Color dayBorder = Color(0xFFE2E8F0);
  static const Color dayCardBg = Color(0xFFF1F5F9);

  // ── Night Theme (18:00 - 05:59) ──
  static const Color nightPrimary = Color(0xFF00D2FF);   // Cyan Neon
  static const Color nightScaffold = Color(0xFF0B1120);  // Deep indigo
  static const Color nightSurface = Color(0xFF111827);   // Dark surface
  static const Color nightCard = Color(0xFF1A2332);      // Card dark
  static const Color nightTextPrimary = Color(0xFF00D2FF); // Cyan text
  static const Color nightTextMuted = Color(0xFF94A3B8);  // Slate gray
  static const Color nightTextDim = Color(0xFF475569);    // Dim
  static const Color nightBorder = Color(0xFF1E293B);     // Dark border
  static const Color nightCardBg = Color(0xFF151E2D);     // Input bg
}

class AppColorsHelper {
  AppColorsHelper._();

  static Color primary(bool isNight) => isNight ? AppColors.nightPrimary : AppColors.dayPrimary;
  static Color scaffold(bool isNight) => isNight ? AppColors.nightScaffold : AppColors.dayScaffold;
  static Color surface(bool isNight) => isNight ? AppColors.nightSurface : AppColors.daySurface;
  static Color card(bool isNight) => isNight ? AppColors.nightCard : AppColors.dayCard;
  static Color textPrimary(bool isNight) => isNight ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
  static Color textMuted(bool isNight) => isNight ? AppColors.nightTextMuted : AppColors.dayTextMuted;
  static Color textDim(bool isNight) => isNight ? AppColors.nightTextDim : AppColors.dayTextDim;
  static Color border(bool isNight) => isNight ? AppColors.nightBorder : AppColors.dayBorder;
  static Color cardBg(bool isNight) => isNight ? AppColors.nightCardBg : AppColors.dayCardBg;
}

class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double hero = 80;
}

class AppRadius {
  AppRadius._();

  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double card = 16;
  static const double pill = 100;
}
