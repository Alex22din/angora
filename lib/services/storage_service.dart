import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final StorageService _instance = StorageService._();
  factory StorageService() => _instance;
  StorageService._();

  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool get isAuthenticated => FirebaseAuth.instance.currentUser != null;

  Future<String?> uploadImage(Uint8List bytes, String itemId, String ext) async {
    if (!isAuthenticated) {
      throw Exception('Not authenticated. Please login first.');
    }

    final ref = _storage.ref().child('menu_images/$itemId.$ext');
    final metadata = SettableMetadata(
      contentType: 'image/$ext',
      cacheControl: 'public, max-age=31536000',
    );
    await ref.putData(bytes, metadata);
    return await ref.getDownloadURL();
  }

  Future<void> deleteImage(String downloadUrl) async {
    if (!isAuthenticated) return;
    try {
      await _storage.refFromURL(downloadUrl).delete();
    } catch (_) {}
  }
}
