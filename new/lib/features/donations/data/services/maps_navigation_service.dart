import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/donation_location.dart';
import '../../domain/repositories/device_location_service.dart';
import '../../domain/usecases/save_donation_location.dart';

class MapsNavigationService implements LocationNavigationService {
  @override
  Future<void> openDirections(GeoPoint point) => _open(directionsUri(point));

  @override
  Future<void> openAttribution() =>
      _open(Uri.parse('https://www.openstreetmap.org/copyright'));

  Future<void> _open(Uri uri) async {
    try {
      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      )) {
        throw const LocationFailure(
          'Harita açılamadı. Tarayıcı açılır pencere izinlerini kontrol edin.',
        );
      }
    } on LocationFailure {
      rethrow;
    } catch (_) {
      throw const LocationFailure(
        'Harita açılamadı. İnternet bağlantısını ve tarayıcı izinlerini kontrol edin.',
      );
    }
  }
}
