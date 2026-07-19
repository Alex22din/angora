import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';
import '../l10n/translations.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  static const _tiktokUrl = 'https://www.tiktok.com/@caftria.angora?_r=1&_t=ZS-98AgeWnVzOr';
  static const _instagramUrl = 'https://www.instagram.com/angora_coffee?igsh=MXhvYTQxcjVlajMxZA==';
  static const _phone = '0562080464';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isPhone = screenWidth < 600;

    return ListenableBuilder(
      listenable: Listenable.merge([ThemeService(), LanguageService()]),
      builder: (context, _) {
        final isNight = ThemeService().isNight;
        final primary = AppColorsHelper.primary(isNight);
        final surface = AppColorsHelper.surface(isNight);
        final border = AppColorsHelper.border(isNight);
        final textDim = AppColorsHelper.textDim(isNight);

        return Container(
          width: double.infinity,
          color: surface,
          padding: EdgeInsets.symmetric(
            horizontal: isPhone ? AppSpacing.md : AppSpacing.xxl,
            vertical: isPhone ? AppSpacing.xl : AppSpacing.xxl,
          ),
          child: Column(
            children: [
              Container(height: 1, width: double.infinity, color: border),
              const SizedBox(height: AppSpacing.xl),
              isPhone ? _buildPhoneLayout(primary, textDim) : _buildWideLayout(primary, textDim),
              const SizedBox(height: AppSpacing.xl),
              Container(height: 1, width: double.infinity, color: border),
              const SizedBox(height: AppSpacing.lg),
              Text(
                T.allRightsReserved,
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: textDim),
              ),
              const SizedBox(height: AppSpacing.sm),
              GestureDetector(
                onTap: () => launchUrl(Uri.parse('https://rahoahmedalaaeddine.online')),
                child: Text(
                  'Made by Raho Ahmed Alaaeddine',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: textDim,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWideLayout(Color primary, Color textDim) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildReservation(primary, textDim),
        _buildLogo(primary),
        _buildSocialIcons(primary, textDim),
      ],
    );
  }

  Widget _buildPhoneLayout(Color primary, Color textDim) {
    return Column(
      children: [
        _buildLogo(primary),
        const SizedBox(height: AppSpacing.lg),
        _buildReservation(primary, textDim),
        const SizedBox(height: AppSpacing.lg),
        _buildSocialIcons(primary, textDim),
      ],
    );
  }

  Widget _buildReservation(Color primary, Color textDim) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse('tel:$_phone')),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.phone, color: Colors.white, size: 18),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                T.forReservations,
                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: textDim),
              ),
              Text(
                _phone,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(Color primary) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'ANGORA',
          style: GoogleFonts.cinzel(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: primary,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(width: 6),
        const Icon(Icons.pets, color: AppColors.secondary, size: 18),
      ],
    );
  }

  Widget _buildSocialIcons(Color primary, Color textDim) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          T.followUs,
          style: GoogleFonts.plusJakartaSans(fontSize: 11, color: textDim),
        ),
        const SizedBox(width: AppSpacing.sm),
        _SocialCircle(
          icon: Icons.tiktok,
          color: primary,
          onTap: () => launchUrl(Uri.parse(_tiktokUrl)),
        ),
        const SizedBox(width: 6),
        _InstagramIcon(
          onTap: () => launchUrl(Uri.parse(_instagramUrl)),
        ),
      ],
    );
  }
}

class _SocialCircle extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SocialCircle({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}

class _InstagramIcon extends StatelessWidget {
  final VoidCallback onTap;

  const _InstagramIcon({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFF58529),
              Color(0xFFDD2A7B),
              Color(0xFF8134AF),
              Color(0xFF515BD4),
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Center(
              child: Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
