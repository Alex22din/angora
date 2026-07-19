import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'menu_data.dart';

class MenuDataManager extends ChangeNotifier {
  static final MenuDataManager _instance = MenuDataManager._();
  factory MenuDataManager() => _instance;
  MenuDataManager._();

  static const String _storageKey = 'angora_menu_data';

  List<MenuCategory> _categories = [];
  bool _loaded = false;

  List<MenuCategory> get categories => _categories;
  bool get isLoaded => _loaded;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_storageKey);

    if (jsonStr != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(jsonStr);
        _categories = jsonList
            .map((c) => MenuCategory.fromJson(c as Map<String, dynamic>))
            .toList();
      } catch (_) {
        _categories = defaultMenuCategories();
      }
    } else {
      _categories = defaultMenuCategories();
    }

    _loaded = true;
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _categories.map((c) => c.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
    notifyListeners();
  }

  // ── Categories ──

  void addCategory(MenuCategory category) {
    _categories.add(category);
    _save();
  }

  void updateCategory(MenuCategory updated) {
    final idx = _categories.indexWhere((c) => c.id == updated.id);
    if (idx != -1) {
      _categories[idx] = updated;
      _save();
    }
  }

  void deleteCategory(String id) {
    _categories.removeWhere((c) => c.id == id);
    _save();
  }

  // ── Subcategories ──

  void addSubcategory(String categoryId, MenuSubcategory sub) {
    final cat = _categories.firstWhere((c) => c.id == categoryId);
    cat.subcategories ??= [];
    cat.subcategories!.add(sub);
    _save();
  }

  void updateSubcategory(String categoryId, MenuSubcategory updated) {
    final cat = _categories.firstWhere((c) => c.id == categoryId);
    if (cat.subcategories != null) {
      final idx = cat.subcategories!.indexWhere((s) => s.id == updated.id);
      if (idx != -1) {
        cat.subcategories![idx] = updated;
        _save();
      }
    }
  }

  void deleteSubcategory(String categoryId, String subId) {
    final cat = _categories.firstWhere((c) => c.id == categoryId);
    cat.subcategories?.removeWhere((s) => s.id == subId);
    _save();
  }

  // ── Items ──

  void addItem(String categoryId, String? subcategoryId, MenuItem item) {
    final cat = _categories.firstWhere((c) => c.id == categoryId);
    if (subcategoryId != null && cat.subcategories != null) {
      final sub = cat.subcategories!.firstWhere((s) => s.id == subcategoryId);
      sub.items.add(item);
    } else {
      cat.items ??= [];
      cat.items!.add(item);
    }
    _save();
  }

  void updateItem(String categoryId, String? subcategoryId, MenuItem updated) {
    final cat = _categories.firstWhere((c) => c.id == categoryId);
    List<MenuItem>? items;
    if (subcategoryId != null && cat.subcategories != null) {
      final sub = cat.subcategories!.firstWhere((s) => s.id == subcategoryId);
      items = sub.items;
    } else {
      items = cat.items;
    }
    if (items != null) {
      final idx = items.indexWhere((i) => i.id == updated.id);
      if (idx != -1) {
        items[idx] = updated;
        _save();
      }
    }
  }

  void deleteItem(String categoryId, String? subcategoryId, String itemId) {
    final cat = _categories.firstWhere((c) => c.id == categoryId);
    if (subcategoryId != null && cat.subcategories != null) {
      final sub = cat.subcategories!.firstWhere((s) => s.id == subcategoryId);
      sub.items.removeWhere((i) => i.id == itemId);
    } else {
      cat.items?.removeWhere((i) => i.id == itemId);
    }
    _save();
  }

  // ── Image Storage ──

  Future<String?> saveImage(File sourceFile, String itemId) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${appDir.path}/menu_images');
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }
      final ext = sourceFile.path.split('.').last;
      final destFile = File('${imagesDir.path}/$itemId.$ext');
      await sourceFile.copy(destFile.path);
      return destFile.path;
    } catch (_) {
      return null;
    }
  }

  Future<void> deleteImage(String? imagePath) async {
    if (imagePath == null) return;
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}
  }

  // ── Helpers ──

  MenuCategory findCategory(String id) {
    return _categories.firstWhere((c) => c.id == id);
  }

  List<MenuItem> getAllItems() {
    final items = <MenuItem>[];
    for (final cat in _categories) {
      if (cat.subcategories != null) {
        for (final sub in cat.subcategories!) {
          items.addAll(sub.items);
        }
      }
      if (cat.items != null) {
        items.addAll(cat.items!);
      }
    }
    return items;
  }
}
