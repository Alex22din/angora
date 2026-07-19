import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/theme_service.dart';
import '../screens/admin/admin_login_screen.dart';

class AngoraNavBar extends StatefulWidget {
  const AngoraNavBar({super.key});

  @override
  State<AngoraNavBar> createState() => _AngoraNavBarState();
}

class _AngoraNavBarState extends State<AngoraNavBar> {
  int _tapCount = 0;
  DateTime? _lastTapTime;

  void _onLogoTap() {
    final now = DateTime.now();
    if (_lastTapTime == null || now.difference(_lastTapTime!) > const Duration(seconds: 2)) {
      _tapCount = 0;
    }
    _lastTapTime = now;
    _tapCount++;

    if (_tapCount >= 5) {
      _tapCount = 0;
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isPhone = screenWidth < 600;

    return ListenableBuilder(
      listenable: ThemeService(),
      builder: (context, _) {
        final isNight = ThemeService().isNight;
        final primary = AppColorsHelper.primary(isNight);
        final scaffold = AppColorsHelper.scaffold(isNight);
        final border = AppColorsHelper.border(isNight);
        final cardBg = AppColorsHelper.cardBg(isNight);
        final textDim = AppColorsHelper.textDim(isNight);
        final textPrimary = AppColorsHelper.textPrimary(isNight);

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isPhone ? AppSpacing.md : AppSpacing.xxl,
            vertical: isPhone ? AppSpacing.md : AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            color: scaffold,
            border: Border(
              bottom: BorderSide(color: border, width: 1),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!isPhone) const SizedBox(width: 100),
                  GestureDetector(
                    onTap: _onLogoTap,
                    child: Text(
                      'ANGORA',
                      style: GoogleFonts.cinzel(
                        fontSize: isPhone ? 20 : 24,
                        fontWeight: FontWeight.w700,
                        color: primary,
                        letterSpacing: 4,
                        shadows: isNight
                            ? [
                                Shadow(
                                  color: primary.withValues(alpha: 0.6),
                                  blurRadius: 12,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                  if (!isPhone)
                    Icon(
                      Icons.shopping_cart_outlined,
                      color: primary,
                      size: 22,
                    )
                  else
                    const SizedBox(width: 100),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isPhone ? double.infinity : 500),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: border),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Icon(Icons.search, color: textDim, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search for dishes...',
                            hintStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: textDim,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
