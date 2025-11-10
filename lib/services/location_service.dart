import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Sprawdza czy usługa lokalizacji jest włączona
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Sprawdza uprawnienia do lokalizacji
  static Future<LocationPermission> checkLocationPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Prosi o uprawnienia do lokalizacji
  static Future<LocationPermission> requestLocationPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Pobiera aktualną pozycję użytkownika
  static Future<Position?> getCurrentPosition() async {
    try {
      // Sprawdź czy usługa lokalizacji jest włączona
      final bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Usługa lokalizacji jest wyłączona');
        return null;
      }

      // Sprawdź uprawnienia
      LocationPermission permission = await checkLocationPermission();
      if (permission == LocationPermission.denied) {
        permission = await requestLocationPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Uprawnienia do lokalizacji zostały odrzucone');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('Uprawnienia do lokalizacji zostały odrzucone na zawsze');
        return null;
      }

      // Pobierz pozycję
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      debugPrint('Pozycja GPS: ${position.latitude}, ${position.longitude}');
      return position;
    } catch (e) {
      debugPrint('Błąd pobierania lokalizacji: $e');
      return null;
    }
  }

  /// Otwiera ustawienia aplikacji
  static Future<void> openAppSettings() async {
    await openAppSettings();
  }

  /// Sprawdza czy można otworzyć ustawienia
  static Future<bool> canOpenAppSettings() async {
    return await canOpenAppSettings();
  }

  /// Formatuje współrzędne do czytelnej formy
  static String formatCoordinates(double latitude, double longitude) {
    return '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
  }
}
