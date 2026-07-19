import 'package:flutter/material.dart';

class LanguageService extends ChangeNotifier {
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  String _currentLanguage = 'fr';
  String get currentLanguage => _currentLanguage;

  bool get isRtl => _currentLanguage == 'ar';

  void setLanguage(String lang) {
    if (lang != _currentLanguage) {
      _currentLanguage = lang;
      notifyListeners();
    }
  }

  String translated(String fr, String? en, String? ar) {
    switch (_currentLanguage) {
      case 'en':
        return en ?? fr;
      case 'ar':
        return ar ?? fr;
      default:
        return fr;
    }
  }
}
