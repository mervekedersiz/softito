import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageServisi {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UploadTask yuklemeBaslat({
    required String hedefDizin,
    required File dosya,
    required String dosyaAdi,
  }) {
    final Reference referans = _storage.ref().child(hedefDizin).child(dosyaAdi);

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'yukleyen': 'çervo'},
    );

    // Yükleme görevini başlatıyoruz
    final UploadTask task = referans.putFile(dosya, metadata);

    // Yükleme ilerlemesini (progress) takip etmek için listener ekledik
    task.snapshotEvents.listen((TaskSnapshot snapshot) {
      final double yuzde =
          (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
      print('Yükleme Yüzdesi: %${yuzde.toStringAsFixed(1)}');
    });

    return task;
  }
}
