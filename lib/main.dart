import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/menu_data_manager.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';
import 'services/firebase_service.dart';
import 'services/theme_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService().init();
  await AuthService().ensureAdminAccount();
  await MenuDataManager().init();
  runApp(const CafeteriaAngoraApp());
}

class CafeteriaAngoraApp extends StatelessWidget {
  const CafeteriaAngoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService(),
      builder: (context, _) {
        final isNight = ThemeService().isNight;
        final primary = AppColorsHelper.primary(isNight);
        final scaffold = AppColorsHelper.scaffold(isNight);
        final surface = AppColorsHelper.surface(isNight);

        return MaterialApp(
          title: 'Cafeteria Angora',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: isNight ? Brightness.dark : Brightness.light,
            scaffoldBackgroundColor: scaffold,
            colorScheme: ColorScheme(
              brightness: isNight ? Brightness.dark : Brightness.light,
              primary: primary,
              onPrimary: Colors.white,
              secondary: AppColors.secondary,
              onSecondary: Colors.white,
              surface: surface,
              onSurface: AppColorsHelper.textPrimary(isNight),
              error: Colors.red,
              onError: Colors.white,
            ),
            textTheme: GoogleFonts.plusJakartaSansTextTheme(
              ThemeData(
                brightness: isNight ? Brightness.dark : Brightness.light,
              ).textTheme,
            ),
            useMaterial3: true,
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}
