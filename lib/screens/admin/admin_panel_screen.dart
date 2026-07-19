import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../services/theme_service.dart';
import '../../models/menu_data.dart';
import '../../models/menu_data_manager.dart';
import 'admin_category_form.dart';
import 'admin_subcategory_form.dart';
import 'admin_item_form.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _manager = MenuDataManager();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _manager.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _manager.removeListener(() {});
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  // ── Category Actions ──

  void _addCategory() async {
    final result = await Navigator.push<MenuCategory>(
      context,
      MaterialPageRoute(builder: (_) => const AdminCategoryForm()),
    );
    if (result != null) {
      _manager.addCategory(result);
      _showSnackBar('Category "${result.name}" added');
    }
  }

  void _editCategory(MenuCategory cat) async {
    final result = await Navigator.push<MenuCategory>(
      context,
      MaterialPageRoute(builder: (_) => AdminCategoryForm(category: cat)),
    );
    if (result != null) {
      _manager.updateCategory(result);
      _showSnackBar('Category updated');
    }
  }

  void _deleteCategory(MenuCategory cat) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Delete "${cat.name}" and all its items?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      _manager.deleteCategory(cat.id);
      _showSnackBar('Category deleted');
    }
  }

  // ── Subcategory Actions ──

  void _addSubcategory(String categoryId) async {
    final result = await Navigator.push<MenuSubcategory>(
      context,
      MaterialPageRoute(
        builder: (_) => AdminSubcategoryForm(categoryId: categoryId),
      ),
    );
    if (result != null) {
      _manager.addSubcategory(categoryId, result);
      _showSnackBar('Subcategory "${result.name}" added');
    }
  }

  void _editSubcategory(String categoryId, MenuSubcategory sub) async {
    final result = await Navigator.push<MenuSubcategory>(
      context,
      MaterialPageRoute(
        builder: (_) => AdminSubcategoryForm(categoryId: categoryId, subcategory: sub),
      ),
    );
    if (result != null) {
      _manager.updateSubcategory(categoryId, result);
      _showSnackBar('Subcategory updated');
    }
  }

  void _deleteSubcategory(String categoryId, MenuSubcategory sub) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Subcategory'),
        content: Text('Delete "${sub.name}" and all its items?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      _manager.deleteSubcategory(categoryId, sub.id);
      _showSnackBar('Subcategory deleted');
    }
  }

  // ── Item Actions ──

  void _addItem(String categoryId, String? subcategoryId) async {
    final result = await Navigator.push<MenuItem>(
      context,
      MaterialPageRoute(
        builder: (_) => AdminItemForm(categoryId: categoryId, subcategoryId: subcategoryId),
      ),
    );
    if (result != null) {
      _manager.addItem(categoryId, subcategoryId, result);
      _showSnackBar('Item "${result.name}" added');
    }
  }

  void _editItem(String categoryId, String? subcategoryId, MenuItem item) async {
    final result = await Navigator.push<MenuItem>(
      context,
      MaterialPageRoute(
        builder: (_) => AdminItemForm(
          categoryId: categoryId,
          subcategoryId: subcategoryId,
          item: item,
        ),
      ),
    );
    if (result != null) {
      _manager.updateItem(categoryId, subcategoryId, result);
      _showSnackBar('Item updated');
    }
  }

  void _deleteItem(String categoryId, String? subcategoryId, MenuItem item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Delete "${item.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      if (item.imageUrl != null) {
        await _manager.deleteImage(item.imageUrl);
      }
      _manager.deleteItem(categoryId, subcategoryId, item.id);
      _showSnackBar('Item deleted');
    }
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
        final cardBg = AppColorsHelper.cardBg(isNight);

        return Scaffold(
          backgroundColor: scaffold,
          appBar: AppBar(
            backgroundColor: scaffold,
            foregroundColor: primary,
            title: Text(
              'Admin Panel',
              style: GoogleFonts.cinzel(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: primary,
                letterSpacing: 1,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.refresh, color: primary),
                onPressed: () => setState(() {}),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              labelColor: primary,
              unselectedLabelColor: textMuted,
              indicatorColor: primary,
              labelStyle: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: 'Categories'),
                Tab(text: 'Subcategories'),
                Tab(text: 'Items'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildCategoriesTab(isNight, primary, card, textPrimary, textMuted, border, cardBg),
              _buildSubcategoriesTab(isNight, primary, card, textPrimary, textMuted, border, cardBg),
              _buildItemsTab(isNight, primary, card, textPrimary, textMuted, border, cardBg),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              switch (_tabController.index) {
                case 0:
                  _addCategory();
                  break;
                case 1:
                  if (_manager.categories.isNotEmpty) {
                    _showCategoryPickerForSubcategory();
                  } else {
                    _showSnackBar('Add a category first');
                  }
                  break;
                case 2:
                  if (_manager.categories.isNotEmpty) {
                    _showCategoryPickerForItem();
                  } else {
                    _showSnackBar('Add a category first');
                  }
                  break;
              }
            },
            backgroundColor: primary,
            foregroundColor: isNight ? AppColors.nightScaffold : Colors.white,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _showCategoryPickerForSubcategory() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        final isNight = ThemeService().isNight;
        final primary = AppColorsHelper.primary(isNight);
        final card = AppColorsHelper.card(isNight);
        final textPrimary = AppColorsHelper.textPrimary(isNight);

        return Container(
          color: card,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(
                  'Select Category',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
              ),
              ..._manager.categories.map((cat) => ListTile(
                    leading: Text(cat.icon, style: const TextStyle(fontSize: 24)),
                    title: Text(cat.name, style: TextStyle(color: textPrimary)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.pop(ctx);
                      _addSubcategory(cat.id);
                    },
                  )),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        );
      },
    );
  }

  void _showCategoryPickerForItem() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        final isNight = ThemeService().isNight;
        final primary = AppColorsHelper.primary(isNight);
        final card = AppColorsHelper.card(isNight);
        final textPrimary = AppColorsHelper.textPrimary(isNight);
        final textMuted = AppColorsHelper.textMuted(isNight);

        return Container(
          color: card,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(
                  'Select Category',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
              ),
              ..._manager.categories.map((cat) => ListTile(
                    leading: Text(cat.icon, style: const TextStyle(fontSize: 24)),
                    title: Text(cat.name, style: TextStyle(color: textPrimary)),
                    subtitle: cat.subcategories != null && cat.subcategories!.isNotEmpty
                        ? Text(
                            '${cat.subcategories!.length} subcategories',
                            style: TextStyle(color: textMuted, fontSize: 12),
                          )
                        : null,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.pop(ctx);
                      if (cat.subcategories != null && cat.subcategories!.isNotEmpty) {
                        _showSubcategoryPickerForItem(cat);
                      } else {
                        _addItem(cat.id, null);
                      }
                    },
                  )),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        );
      },
    );
  }

  void _showSubcategoryPickerForItem(MenuCategory cat) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        final isNight = ThemeService().isNight;
        final primary = AppColorsHelper.primary(isNight);
        final card = AppColorsHelper.card(isNight);
        final textPrimary = AppColorsHelper.textPrimary(isNight);

        return Container(
          color: card,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(
                  'Select Subcategory',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.close, size: 20),
                title: Text('Directly in ${cat.name}',
                    style: TextStyle(color: textPrimary)),
                onTap: () {
                  Navigator.pop(ctx);
                  _addItem(cat.id, null);
                },
              ),
              ...cat.subcategories!.map((sub) => ListTile(
                    title: Text(sub.name, style: TextStyle(color: textPrimary)),
                    subtitle: Text('${sub.items.length} items',
                        style: TextStyle(color: textPrimary.withValues(alpha: 0.5), fontSize: 12)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.pop(ctx);
                      _addItem(cat.id, sub.id);
                    },
                  )),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        );
      },
    );
  }

  // ── Tabs ──

  Widget _buildCategoriesTab(
    bool isNight, Color primary, Color card, Color textPrimary,
    Color textMuted, Color border, Color cardBg,
  ) {
    final categories = _manager.categories;

    if (categories.isEmpty) {
      return Center(
        child: Text('No categories yet', style: TextStyle(color: textMuted)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        final itemCount = cat.subcategories != null
            ? cat.subcategories!.fold<int>(0, (sum, s) => sum + s.items.length)
            : (cat.items?.length ?? 0);

        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: border),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
            leading: Text(cat.icon, style: const TextStyle(fontSize: 28)),
            title: Text(
              cat.name,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            subtitle: Text(
              '$itemCount items',
              style: GoogleFonts.plusJakartaSans(fontSize: 12, color: textMuted),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, size: 20, color: primary),
                  onPressed: () => _editCategory(cat),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                  onPressed: () => _deleteCategory(cat),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubcategoriesTab(
    bool isNight, Color primary, Color card, Color textPrimary,
    Color textMuted, Color border, Color cardBg,
  ) {
    final allSubs = <MapEntry<MenuCategory, MenuSubcategory>>[];
    for (final cat in _manager.categories) {
      if (cat.subcategories != null) {
        for (final sub in cat.subcategories!) {
          allSubs.add(MapEntry(cat, sub));
        }
      }
    }

    if (allSubs.isEmpty) {
      return Center(
        child: Text('No subcategories yet', style: TextStyle(color: textMuted)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: allSubs.length,
      itemBuilder: (context, index) {
        final entry = allSubs[index];
        final cat = entry.key;
        final sub = entry.value;

        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: border),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
            leading: Text(cat.icon, style: const TextStyle(fontSize: 24)),
            title: Text(
              sub.name,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            subtitle: Text(
              '${cat.name} • ${sub.items.length} items',
              style: GoogleFonts.plusJakartaSans(fontSize: 12, color: textMuted),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, size: 20, color: primary),
                  onPressed: () => _editSubcategory(cat.id, sub),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                  onPressed: () => _deleteSubcategory(cat.id, sub),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildItemsTab(
    bool isNight, Color primary, Color card, Color textPrimary,
    Color textMuted, Color border, Color cardBg,
  ) {
    final allItems = <MapEntry3<MenuCategory, MenuSubcategory?, MenuItem>>[];
    for (final cat in _manager.categories) {
      if (cat.subcategories != null) {
        for (final sub in cat.subcategories!) {
          for (final item in sub.items) {
            allItems.add(MapEntry3(cat, sub, item));
          }
        }
      }
      if (cat.items != null) {
        for (final item in cat.items!) {
          allItems.add(MapEntry3(cat, null, item));
        }
      }
    }

    if (allItems.isEmpty) {
      return Center(
        child: Text('No items yet', style: TextStyle(color: textMuted)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: allItems.length,
      itemBuilder: (context, index) {
        final entry = allItems[index];
        final cat = entry.a;
        final sub = entry.b;
        final item = entry.c;

        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: border),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: item.imageUrl != null
                  ? Image.file(
                      File(item.imageUrl!),
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, e, s) => Container(
                        width: 48,
                        height: 48,
                        color: cardBg,
                        child: Text(cat.icon, style: const TextStyle(fontSize: 24)),
                      ),
                    )
                  : Container(
                      width: 48,
                      height: 48,
                      color: cardBg,
                      child: Text(cat.icon, style: const TextStyle(fontSize: 24)),
                    ),
            ),
            title: Text(
              item.name,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            subtitle: Text(
              '${cat.name}${sub != null ? ' • ${sub.name}' : ''} • ${item.priceDisplay}',
              style: GoogleFonts.plusJakartaSans(fontSize: 11, color: textMuted),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, size: 20, color: primary),
                  onPressed: () => _editItem(cat.id, sub?.id, item),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                  onPressed: () => _deleteItem(cat.id, sub?.id, item),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MapEntry3<A, B, C> {
  final A a;
  final B b;
  final C c;
  const MapEntry3(this.a, this.b, this.c);
}
