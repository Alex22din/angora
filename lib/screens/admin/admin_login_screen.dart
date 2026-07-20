import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/theme_service.dart';
import 'admin_panel_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  String? _error;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = 'angora@gmail.com';
  }

  void _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _error = 'Email and password are required';
        _loading = false;
      });
      return;
    }

    final error = await AuthService().login(email, password);

    if (error != null) {
      setState(() {
        _error = error;
        _loading = false;
      });
      return;
    }

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AdminPanelScreen()),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeService(),
      builder: (context, _) {
        final isNight = ThemeService().isNight;
        final primary = AppColorsHelper.primary(isNight);
        final scaffold = AppColorsHelper.scaffold(isNight);
        final card = AppColorsHelper.card(isNight);
        final textPrimary = AppColorsHelper.textPrimary(isNight);
        final textMuted = AppColorsHelper.textMuted(isNight);
        final border = AppColorsHelper.border(isNight);

        return Scaffold(
          backgroundColor: scaffold,
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.15),
                      blurRadius: 32,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_outline, size: 48, color: primary),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Admin Panel',
                      style: GoogleFonts.cinzel(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: primary,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Sign in to continue',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: textMuted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        color: textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: GoogleFonts.plusJakartaSans(color: textMuted),
                        prefixIcon: Icon(Icons.email_outlined, color: textMuted, size: 20),
                        filled: true,
                        fillColor: AppColorsHelper.cardBg(isNight),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          borderSide: BorderSide(color: border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          borderSide: BorderSide(color: border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          borderSide: BorderSide(color: primary, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscure,
                      onSubmitted: (_) => _login(),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        color: textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: GoogleFonts.plusJakartaSans(color: textMuted),
                        prefixIcon: Icon(Icons.vpn_key, color: textMuted, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure ? Icons.visibility_off : Icons.visibility,
                            color: textMuted,
                            size: 20,
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                        filled: true,
                        fillColor: AppColorsHelper.cardBg(isNight),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          borderSide: BorderSide(color: border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          borderSide: BorderSide(color: border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          borderSide: BorderSide(color: primary, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        errorText: _error,
                        errorStyle: GoogleFonts.plusJakartaSans(fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: isNight ? AppColors.nightScaffold : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          elevation: 0,
                        ),
                        child: _loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Login',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Back to Menu',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
