import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<String?> saveImageBytes(Uint8List bytes, String itemId, String ext) async {
  try {
    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${appDir.path}/menu_images');
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    final destFile = File('${imagesDir.path}/$itemId.$ext');
    await destFile.writeAsBytes(bytes);
    return destFile.path;
  } catch (_) {
    return null;
  }
}

Future<void> deleteImageFile(String path) async {
  try {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  } catch (_) {}
}

Future<Uint8List?> readFileBytes(String path) async {
  try {
    return await File(path).readAsBytes();
  } catch (_) {
    return null;
  }
}

Widget buildImageFromFile(
  String path, {
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
  ImageErrorWidgetBuilder? errorBuilder,
  Widget? fallback,
}) {
  return Image.file(
    File(path),
    width: width,
    height: height,
    fit: fit,
    errorBuilder: errorBuilder,
  );
}
