import '../services/language_service.dart';

class T {
  static String _t(String fr, String en, String ar) {
    return LanguageService().translated(fr, en, ar);
  }

  static String get ourMenu => _t('Notre Menu', 'Our Menu', 'قائمتنا');
  static String get searchHint => _t('Rechercher des plats...', 'Search for dishes...', '...ابحث عن الأطباق');
  static String get viewDetails => _t('Voir détails >', 'View details >', '> عرض التفاصيل');
  static String get ingredients => _t('INGRÉDIENTS', 'INGREDIENTS', 'المكونات');
  static String get noIngredients => _t('Aucun ingrédient listé', 'No ingredients listed', 'لا توجد مكونات مدرجة');
  static String get close => _t('Fermer', 'Close', 'إغلاق');
  static String get from => _t('À partir de', 'From', 'ابتداءً من');
  static String ingredientsCount(int count) {
    return _t('$count ingrédient${count > 1 ? 's' : ''}', '$count ingredient${count > 1 ? 's' : ''}', '$count مكون${count > 1 ? 'ات' : ''}');
  }

  static String get heroTitle => _t(
    'Bonne vue, beau cadre,\nmoments inoubliables.',
    'Good food, beautiful view,\nunforgettable moments.',
    'طعام لذيذ، منظر جميل،\nلحظات لا تُنسى.',
  );
  static String get heroSubtitle => _t(
    'Expérience de cafétéria premium avec des plats\nfaits main et un cadre à couper le souffle.',
    'Premium cafeteria experience with handcrafted dishes\nand breathtaking ambiance.',
    'تجربة مقهى فاخرة مع أطباق يدوية\nوجو خلاب.',
  );
  static String get heroTitlePhone => _t(
    'Bonne vue, beau cadre, moments inoubliables.',
    'Good food, beautiful view, unforgettable moments.',
    'طعام لذيذ، منظر جميل، لحظات لا تُنسى.',
  );
  static String get heroSubtitlePhone => _t(
    'Expérience de cafétéria premium.',
    'Premium cafeteria experience.',
    'تجربة مقهى فاخرة.',
  );

  static String get forReservations => _t('Réservations', 'For Reservations', 'للحجوزات');
  static String get followUs => _t('Suivez-nous', 'Follow Us', 'تابعونا');
  static String get allRightsReserved => _t(
    'Cafétéria Angora. Tous droits réservés.',
    'Cafeteria Angora. All rights reserved.',
    'مقهى أنقورا. جميع الحقوق محفوظة.',
  );
}
