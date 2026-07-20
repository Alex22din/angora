import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final StorageService _instance = StorageService._();
  factory StorageService() => _instance;
  StorageService._();

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadImage(Uint8List bytes, String itemId, String ext) async {
    try {
      final ref = _storage.ref().child('menu_images/$itemId.$ext');
      final metadata = SettableMetadata(
        contentType: 'image/$ext',
        cacheControl: 'public, max-age=31536000',
      );
      await ref.putData(bytes, metadata);
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteImage(String downloadUrl) {
    try {
      return _storage.refFromURL(downloadUrl).delete();
    } catch (_) {
      return Future.value();
    }
  }
}
