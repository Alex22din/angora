import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';
import '../models/menu_data.dart';
import '../models/menu_data_manager.dart';
import '../l10n/translations.dart';
import 'menu_item_card.dart';

class MenuSection extends StatefulWidget {
  const MenuSection({super.key});

  @override
  State<MenuSection> createState() => _MenuSectionState();
}

class _MenuSectionState extends State<MenuSection> {
  int _selectedCategoryIndex = 0;
  final _manager = MenuDataManager();

  @override
  void initState() {
    super.initState();
    _manager.addListener(_onDataChanged);
    LanguageService().addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _manager.removeListener(_onDataChanged);
    LanguageService().removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isPhone = screenWidth < 600;
    final menuCategories = _manager.categories;

    if (_selectedCategoryIndex >= menuCategories.length) {
      _selectedCategoryIndex = 0;
    }

    return ListenableBuilder(
      listenable: Listenable.merge([ThemeService(), LanguageService()]),
      builder: (context, _) {
        final isNight = ThemeService().isNight;
        final primary = AppColorsHelper.primary(isNight);
        final surface = AppColorsHelper.surface(isNight);
        final textPrimary = AppColorsHelper.textPrimary(isNight);
        final textMuted = AppColorsHelper.textMuted(isNight);
        final border = AppColorsHelper.border(isNight);
        final cardBg = AppColorsHelper.cardBg(isNight);

        return Container(
          width: double.infinity,
          color: surface,
          padding: EdgeInsets.symmetric(
            horizontal: isPhone ? AppSpacing.md : AppSpacing.xxl,
            vertical: isPhone ? AppSpacing.xxl : AppSpacing.hero,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 28,
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    T.ourMenu,
                    style: GoogleFonts.cinzel(
                      fontSize: isPhone ? 22 : 28,
                      fontWeight: FontWeight.w600,
                      color: primary,
                      letterSpacing: 2,
                      shadows: isNight
                          ? [
                              Shadow(
                                color: primary.withValues(alpha: 0.4),
                                blurRadius: 8,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildCategorySelector(
                menuCategories, isNight, primary, textPrimary, border, cardBg, isPhone,
              ),
              const SizedBox(height: AppSpacing.xl),
              _buildCategoryContent(
                menuCategories, isNight, primary, textPrimary, textMuted, border, isPhone,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategorySelector(
    List<MenuCategory> menuCategories,
    bool isNight, Color primary, Color textPrimary, Color border, Color cardBg, bool isPhone,
  ) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: menuCategories.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final cat = menuCategories[index];
          final isSelected = index == _selectedCategoryIndex;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategoryIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: isPhone ? 14 : 20),
              decoration: BoxDecoration(
                color: isSelected ? cardBg : Colors.transparent,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isSelected ? border : Colors.transparent,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(cat.icon, style: TextStyle(fontSize: isPhone ? 16 : 18)),
                  const SizedBox(width: 6),
                  Text(
                    cat.localizedName,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: isPhone ? 12 : 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? primary : textPrimary.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryContent(
    List<MenuCategory> menuCategories,
    bool isNight, Color primary, Color textPrimary, Color textMuted, Color border, bool isPhone,
  ) {
    final category = menuCategories[_selectedCategoryIndex];

    if (category.subcategories != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: category.subcategories!.map((sub) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 3,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      sub.localizedName,
                      style: GoogleFonts.cinzel(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: primary,
                        letterSpacing: 1,
                        shadows: isNight
                            ? [
                                Shadow(
                                  color: primary.withValues(alpha: 0.3),
                                  blurRadius: 6,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                ...sub.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: MenuItemCard(item: item, categoryIcon: category.icon),
                )),
              ],
            ),
          );
        }).toList(),
      );
    }

    if (category.items != null) {
      return Column(
        children: category.items!.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: MenuItemCard(item: item, categoryIcon: category.icon),
        )).toList(),
      );
    }

    return const SizedBox.shrink();
  }
}
