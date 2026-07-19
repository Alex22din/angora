import 'dart:async';
import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal() {
    _updateTheme();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => _updateTheme());
  }

  late Timer _timer;
  bool _isNight = false;
  bool get isNight => _isNight;

  void _updateTheme() {
    final hour = DateTime.now().hour;
    final newIsNight = hour >= 18 || hour < 6;
    if (newIsNight != _isNight) {
      _isNight = newIsNight;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
