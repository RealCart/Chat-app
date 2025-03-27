import 'dart:io';

import 'package:image_picker/image_picker.dart';

class MediaImage {
  final ImagePicker _imagePicker = ImagePicker();

  Future<File?> getImageInGallery() async {
    final XFile? _image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (_image != null) return File(_image.path);

    return null;
  }
}
