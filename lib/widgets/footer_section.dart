import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';
import '../l10n/translations.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

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
    return Row(
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
              '+213 555 12 34 56',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: primary,
              ),
            ),
          ],
        ),
      ],
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
        _SocialCircle(icon: Icons.facebook, color: primary),
        const SizedBox(width: 6),
        _SocialCircle(icon: Icons.camera_alt_outlined, color: primary),
        const SizedBox(width: 6),
        _SocialCircle(icon: Icons.music_note, color: primary),
      ],
    );
  }
}

class _SocialCircle extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _SocialCircle({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 16),
    );
  }
}
