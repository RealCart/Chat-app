import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageUtils {
  static Future<String> imageFileToBase64(File file) async {
    final bytes = await file.readAsBytes();
    final compressedBytes = await FlutterImageCompress.compressWithList(
      bytes,
      quality: 80,
    );
    return base64Encode(compressedBytes);
  }

  static Uint8List base64ToImageBytes(String base64String) {
    return base64Decode(base64String);
  }
}
