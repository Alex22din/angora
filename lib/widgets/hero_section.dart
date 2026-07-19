import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';
import '../l10n/translations.dart';
import 'wave_separator.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  late final Timer _timer;
  int _currentIndex = 0;

  static const _images = [
    'assets/images/angoracat1.png',
    'assets/images/angoracat2.png',
    'assets/images/angoracat3.png',
    'assets/images/angoracat4.png',
    'assets/images/angoracat5.png',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _images.length;
      });
    });
    LanguageService().addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    _timer.cancel();
    LanguageService().removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isPhone = screenWidth < 600;

    return ListenableBuilder(
      listenable: Listenable.merge([ThemeService(), LanguageService()]),
      builder: (context, _) {
        final isNight = ThemeService().isNight;

        return Column(
          children: [
            Container(
              width: double.infinity,
              height: isPhone ? 400 : 520,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_images[_currentIndex]),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.2),
                      Colors.black.withValues(alpha: 0.5),
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isPhone ? AppSpacing.md : AppSpacing.xxl,
                    vertical: isPhone ? AppSpacing.xl : AppSpacing.xxl,
                  ),
                  child: isPhone
                      ? _buildPhoneLayout(isNight)
                      : _buildWideLayout(isNight),
                ),
              ),
            ),
            WaveSeparator(
              color: isNight ? AppColors.nightScaffold : Colors.white,
              height: 50,
            ),
          ],
        );
      },
    );
  }

  Widget _buildWideLayout(bool isNight) {
    final primary = isNight ? AppColors.nightPrimary : Colors.white;

    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                T.heroTitle,
                style: GoogleFonts.cinzel(
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                  color: primary,
                  height: 1.2,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.6),
                      blurRadius: 16,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                T.heroSubtitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  color: primary.withValues(alpha: 0.9),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneLayout(bool isNight) {
    final primary = isNight ? AppColors.nightPrimary : Colors.white;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          T.heroTitlePhone,
          textAlign: TextAlign.center,
          style: GoogleFonts.cinzel(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: primary,
            height: 1.3,
            letterSpacing: 1.5,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.6),
                blurRadius: 12,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          T.heroSubtitlePhone,
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: primary.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }
}
