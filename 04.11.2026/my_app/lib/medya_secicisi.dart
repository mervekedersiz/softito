import 'dart:io';

import 'package:image_picker/image_picker.dart';

class MedyaSecicisiService {
  final ImagePicker _imagePicker = ImagePicker();

  // Galeriden resim seçme
  Future<File?> galeridenSec() async {
    final XFile? secilen = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80, // Küçük harf olmalı
      maxWidth: 1200,
    );

    if (secilen == null) return null;
    return File(secilen.path);
  }

  // Kameradan resim çekme
  Future<File?> kameradanSec() async {
    final XFile? secilen = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80, // Küçük harf olmalı
      maxWidth: 1200,
    );

    if (secilen == null) return null;
    return File(secilen.path);
  }
}
