import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';
import '../services/search_service.dart';
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
  final _searchService = SearchService();

  @override
  void initState() {
    super.initState();
    _manager.addListener(_onDataChanged);
    LanguageService().addListener(_onDataChanged);
    _searchService.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _manager.removeListener(_onDataChanged);
    LanguageService().removeListener(_onDataChanged);
    _searchService.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  List<_SearchResult> _searchMenu(String query) {
    final results = <_SearchResult>[];
    final q = query.toLowerCase();
    for (final cat in _manager.categories) {
      for (final item in cat.items ?? []) {
        if (_itemMatches(item, q)) {
          results.add(_SearchResult(category: cat, item: item));
        }
      }
      for (final sub in cat.subcategories ?? []) {
        if (_subMatches(sub, q)) {
          for (final item in sub.items) {
            results.add(_SearchResult(category: cat, subcategory: sub, item: item));
          }
        } else {
          for (final item in sub.items) {
            if (_itemMatches(item, q)) {
              results.add(_SearchResult(category: cat, subcategory: sub, item: item));
            }
          }
        }
      }
    }
    return results;
  }

  bool _subMatches(MenuSubcategory sub, String query) {
    if (sub.localizedName.toLowerCase().contains(query)) return true;
    if (sub.name.toLowerCase().contains(query)) return true;
    if (sub.nameEn?.toLowerCase().contains(query) == true) return true;
    if (sub.nameAr?.toLowerCase().contains(query) == true) return true;
    return false;
  }

  bool _itemMatches(MenuItem item, String query) {
    if (item.localizedName.toLowerCase().contains(query)) return true;
    if (item.name.toLowerCase().contains(query)) return true;
    if (item.nameEn?.toLowerCase().contains(query) == true) return true;
    if (item.nameAr?.toLowerCase().contains(query) == true) return true;
    if (item.localizedDescription?.toLowerCase().contains(query) == true) return true;
    if (item.description?.toLowerCase().contains(query) == true) return true;
    if (item.descriptionEn?.toLowerCase().contains(query) == true) return true;
    if (item.descriptionAr?.toLowerCase().contains(query) == true) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isPhone = screenWidth < 600;
    final menuCategories = _manager.categories;
    final query = _searchService.query;

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
                    query.isEmpty ? T.ourMenu : '${T.ourMenu} - "$query"',
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
              if (query.isEmpty) ...[
                _buildCategorySelector(
                  menuCategories, isNight, primary, textPrimary, border, cardBg, isPhone,
                ),
                const SizedBox(height: AppSpacing.xl),
                _buildCategoryContent(
                  menuCategories, isNight, primary, textPrimary, textMuted, border, isPhone,
                ),
              ] else
                _buildSearchResults(
                  query, isNight, primary, textPrimary, textMuted, border, cardBg, isPhone,
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

  Widget _buildSearchResults(
    String query,
    bool isNight, Color primary, Color textPrimary, Color textMuted, Color border, Color cardBg, bool isPhone,
  ) {
    final results = _searchMenu(query);

    if (results.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.search_off, size: 48, color: textMuted),
              const SizedBox(height: AppSpacing.md),
              Text(
                LanguageService().translated(
                  'Aucun résultat pour "$query"',
                  'No results for "$query"',
                  'لا توجد نتائج لـ"$query"',
                ),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  color: textMuted,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Group results by category, then by subcategory
    final grouped = <String, _CategoryGroup>{};
    for (final r in results) {
      grouped.putIfAbsent(
        r.category.id,
        () => _CategoryGroup(category: r.category),
      );
      final subKey = r.subcategory?.id ?? '__direct__';
      grouped[r.category.id]!.items.putIfAbsent(
        subKey,
        () => _SubGroup(subcategory: r.subcategory),
      ).items.add(r.item);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LanguageService().translated(
            '${results.length} résultat${results.length > 1 ? 's' : ''}',
            '${results.length} result${results.length > 1 ? 's' : ''}',
            '${results.length} نتيجة',
          ),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: textMuted,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ...grouped.values.map((catGroup) {
          final cat = catGroup.category;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category header
                Row(
                  children: [
                    Text(cat.icon, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      cat.localizedName,
                      style: GoogleFonts.cinzel(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: primary,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                // Subcategories + items
                ...catGroup.items.entries.map((subEntry) {
                  final subGroup = subEntry.value;
                  final items = subGroup.items;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (subGroup.subcategory != null) ...[
                          Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: AppSpacing.sm),
                            child: Row(
                              children: [
                                Container(
                                  width: 3,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  subGroup.subcategory!.localizedName,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...items.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: MenuItemCard(item: item, categoryIcon: cat.icon),
                          )),
                        ] else ...[
                          ...items.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: MenuItemCard(item: item, categoryIcon: cat.icon),
                          )),
                        ],
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _SubGroup {
  final MenuSubcategory? subcategory;
  final List<MenuItem> items = [];
  _SubGroup({required this.subcategory});
}

class _CategoryGroup {
  final MenuCategory category;
  final Map<String, _SubGroup> items = {};
  _CategoryGroup({required this.category});
}

class _SearchResult {
  final MenuCategory category;
  final MenuSubcategory? subcategory;
  final MenuItem item;
  const _SearchResult({required this.category, this.subcategory, required this.item});
}
