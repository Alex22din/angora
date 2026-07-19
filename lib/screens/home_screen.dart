import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/theme_service.dart';
import '../widgets/navigation_bar.dart';
import '../widgets/hero_section.dart';
import '../widgets/menu_section.dart';
import '../widgets/footer_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService(),
      builder: (context, _) {
        final isNight = ThemeService().isNight;

        return Scaffold(
          backgroundColor: AppColorsHelper.scaffold(isNight),
          body: Column(
            children: [
              const AngoraNavBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: const [
                      HeroSection(),
                      MenuSection(),
                      FooterSection(),
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
