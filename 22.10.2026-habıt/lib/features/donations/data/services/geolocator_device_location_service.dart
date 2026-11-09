import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../../domain/entities/donation_location.dart';
import '../../domain/repositories/device_location_service.dart';

class GeolocatorDeviceLocationService implements DeviceLocationService {
  @override
  Future<GeoPoint> currentPosition() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw const LocationFailure(
          'Konum hizmetleri kapalı. Cihazınızda konumu açın veya haritadan pin seçin.',
        );
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        throw LocationFailure(
          kIsWeb
              ? 'Konum izni verilmedi. Tarayıcının site ayarlarından konuma izin verin veya haritadan pin seçin.'
              : 'Konum izni verilmedi. Uygulama ayarlarından konuma izin verin veya haritadan pin seçin.',
        );
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );
      return GeoPoint(position.latitude, position.longitude);
    } on LocationFailure {
      rethrow;
    } on TimeoutException {
      throw const LocationFailure(
        'Konum zamanında alınamadı. Tekrar deneyin veya haritadan pin seçin.',
      );
    } catch (_) {
      throw LocationFailure(
        kIsWeb
            ? 'Konum alınamadı. GPS için localhost veya HTTPS üzerinden açın; site konum iznini kontrol edin. Haritadan da pin seçebilirsiniz.'
            : 'Konum alınamadı. GPS ve uygulama izinlerini kontrol edip tekrar deneyin. Haritadan da pin seçebilirsiniz.',
      );
    }
  }
}
