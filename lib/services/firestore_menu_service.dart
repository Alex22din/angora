import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/menu_data.dart';

class FirestoreMenuService {
  static final FirestoreMenuService _instance = FirestoreMenuService._();
  factory FirestoreMenuService() => _instance;
  FirestoreMenuService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'categories';

  Future<List<MenuCategory>> loadCategories() async {
    try {
      final snapshot = await _db.collection(_collection).orderBy('name').get();
      return snapshot.docs
          .map((doc) => MenuCategory.fromJson(doc.data()))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> hasData() async {
    final snapshot = await _db.collection(_collection).limit(1).get();
    return snapshot.docs.isNotEmpty;
  }

  Future<void> seedCategories(List<MenuCategory> categories) async {
    final batch = _db.batch();
    for (final cat in categories) {
      final ref = _db.collection(_collection).doc(cat.id);
      batch.set(ref, cat.toJson());
    }
    await batch.commit();
  }

  Future<void> saveCategory(MenuCategory category) async {
    await _db.collection(_collection).doc(category.id).set(category.toJson());
  }

  Future<void> updateCategory(MenuCategory category) async {
    await _db.collection(_collection).doc(category.id).update(category.toJson());
  }

  Future<void> deleteCategory(String id) async {
    await _db.collection(_collection).doc(id).delete();
  }

  Future<void> saveAll(List<MenuCategory> categories) async {
    final batch = _db.batch();

    final existing = await _db.collection(_collection).get();
    for (final doc in existing.docs) {
      batch.delete(doc.reference);
    }

    for (final cat in categories) {
      final ref = _db.collection(_collection).doc(cat.id);
      batch.set(ref, cat.toJson());
    }

    await batch.commit();
  }
}
