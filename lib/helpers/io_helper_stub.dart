import 'dart:typed_data';
import 'package:flutter/material.dart';

Future<String?> saveImageBytes(Uint8List bytes, String itemId, String ext) async {
  return null;
}

Future<void> deleteImageFile(String path) async {}

Future<Uint8List?> readFileBytes(String path) async {
  return null;
}

Widget buildImageFromFile(
  String path, {
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
  ImageErrorWidgetBuilder? errorBuilder,
  Widget? fallback,
}) {
  return fallback ?? const SizedBox();
}
