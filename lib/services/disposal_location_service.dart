import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/disposal_location.dart';

/// Serwis do zarządzania lokalizacjami utylizacji odpadów
class DisposalLocationService {
  factory DisposalLocationService() => _instance;
  DisposalLocationService._internal();
  static final DisposalLocationService _instance =
      DisposalLocationService._internal();

  List<DisposalLocation> _locations = [];
  bool _isLoaded = false;

  /// Załaduj lokalizacje z pliku JSON
  Future<void> loadLocations() async {
    if (_isLoaded) return;

    try {
      final String jsonString = await rootBundle.loadString(
        'lib/data/disposal_locations.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString) as List<dynamic>;
      final List<dynamic> locationsJson = jsonData;

      _locations = locationsJson
          .map(
            (json) => DisposalLocation.fromJson(json as Map<String, dynamic>),
          )
          .toList();

      _isLoaded = true;
    } catch (e) {
      debugPrint('Błąd ładowania lokalizacji: $e');
      _locations = [];
    }
  }

  /// Pobierz wszystkie lokalizacje
  Future<List<DisposalLocation>> getAllLocations() async {
    await loadLocations();
    return List.from(_locations);
  }

  /// Pobierz lokalizacje według typu
  Future<List<DisposalLocation>> getLocationsByType(String type) async {
    await loadLocations();
    return _locations
        .where((location) => location.type.toLowerCase() == type.toLowerCase())
        .toList();
  }

  /// Pobierz lokalizacje przyjmujące dany typ odpadu
  Future<List<DisposalLocation>> getLocationsForWasteType(
    String wasteType,
  ) async {
    await loadLocations();
    return _locations
        .where((location) => location.acceptsWasteType(wasteType))
        .toList();
  }

  /// Pobierz lokalizacje w pobliżu danej lokalizacji
  Future<List<DisposalLocation>> getLocationsNearby(
    Coordinates userLocation, {
    double radiusKm = 10.0,
  }) async {
    await loadLocations();
    return _locations.where((location) {
      final distance = userLocation.distanceTo(location.coordinates);
      return distance <= radiusKm;
    }).toList();
  }

  /// Pobierz najbliższą lokalizację dla danego typu odpadu
  Future<DisposalLocation?> getNearestLocationForWasteType(
    Coordinates userLocation,
    String wasteType,
  ) async {
    await loadLocations();

    final suitableLocations = _locations
        .where((location) => location.acceptsWasteType(wasteType))
        .toList();

    if (suitableLocations.isEmpty) return null;

    suitableLocations.sort((a, b) {
      final distanceA = userLocation.distanceTo(a.coordinates);
      final distanceB = userLocation.distanceTo(b.coordinates);
      return distanceA.compareTo(distanceB);
    });

    return suitableLocations.first;
  }

  /// Pobierz lokalizacje otwarte w danym dniu
  Future<List<DisposalLocation>> getLocationsOpenOnDay(String day) async {
    await loadLocations();
    return _locations.where((location) => location.isOpenOnDay(day)).toList();
  }

  /// Pobierz lokalizacje otwarte teraz (uproszczona logika)
  Future<List<DisposalLocation>> getLocationsOpenNow() async {
    await loadLocations();
    final now = DateTime.now();
    final dayNames = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    final currentDay = dayNames[now.weekday - 1];

    return _locations
        .where((location) => location.isOpenOnDay(currentDay))
        .toList();
  }

  /// Wyszukaj lokalizacje po nazwie lub adresie
  Future<List<DisposalLocation>> searchLocations(String query) async {
    await loadLocations();
    if (query.isEmpty) return _locations;

    final lowerCaseQuery = query.toLowerCase();
    return _locations
        .where(
          (location) =>
              location.name.toLowerCase().contains(lowerCaseQuery) ||
              location.address.toLowerCase().contains(lowerCaseQuery) ||
              location.type.toLowerCase().contains(lowerCaseQuery),
        )
        .toList();
  }

  /// Pobierz statystyki lokalizacji
  Future<Map<String, dynamic>> getLocationStats() async {
    await loadLocations();

    final stats = <String, dynamic>{};
    final typeCounts = <String, int>{};

    for (final location in _locations) {
      typeCounts[location.type] = (typeCounts[location.type] ?? 0) + 1;
    }

    stats['totalLocations'] = _locations.length;
    stats['typeCounts'] = typeCounts;
    stats['averageServicesPerLocation'] =
        _locations.fold(0, (sum, location) => sum + location.services.length) /
        _locations.length;

    return stats;
  }

  /// Pobierz rekomendacje lokalizacji dla danego odpadu
  Future<List<DisposalLocation>> getRecommendationsForWaste(
    String wasteType, {
    int count = 3,
  }) async {
    await loadLocations();

    final suitableLocations = _locations
        .where((location) => location.acceptsWasteType(wasteType))
        .toList();

    // Sortuj według liczby usług (więcej usług = lepsza rekomendacja)
    suitableLocations.sort(
      (a, b) => b.services.length.compareTo(a.services.length),
    );

    return suitableLocations.take(count).toList();
  }

  /// Pobierz lokalizacje według usługi
  Future<List<DisposalLocation>> getLocationsByService(String service) async {
    await loadLocations();
    return _locations
        .where(
          (location) => location.services.any(
            (s) => s.toLowerCase().contains(service.toLowerCase()),
          ),
        )
        .toList();
  }

  /// Pobierz lokalizacje z bezpłatną zbiórką
  Future<List<DisposalLocation>> getFreeCollectionLocations() async {
    await loadLocations();
    return _locations
        .where(
          (location) => location.services.any(
            (service) => service.toLowerCase().contains('bezpłat'),
          ),
        )
        .toList();
  }

  /// Pobierz lokalizacje z konsultacjami
  Future<List<DisposalLocation>> getConsultationLocations() async {
    await loadLocations();
    return _locations
        .where(
          (location) => location.services.any(
            (service) => service.toLowerCase().contains('konsult'),
          ),
        )
        .toList();
  }

  /// Pobierz lokalizacje z warsztatami
  Future<List<DisposalLocation>> getWorkshopLocations() async {
    await loadLocations();
    return _locations
        .where(
          (location) => location.services.any(
            (service) => service.toLowerCase().contains('warsztat'),
          ),
        )
        .toList();
  }

  /// Pobierz lokalizacje według godziny otwarcia
  Future<List<DisposalLocation>> getLocationsByOpeningHours(
    String day,
    String time,
  ) async {
    await loadLocations();
    return _locations.where((location) {
      final hours = location.getOpeningHoursForDay(day);
      if (hours == 'Zamknięte' || hours == '24/7') return hours == '24/7';

      // Prosta logika sprawdzania godzin (można rozszerzyć)
      return true;
    }).toList();
  }

  /// Pobierz lokalizacje z określonymi wymaganiami
  Future<List<DisposalLocation>> getLocationsWithRequirements() async {
    await loadLocations();
    return _locations
        .where(
          (location) =>
              location.notes?.toLowerCase().contains('wymagane') ?? false,
        )
        .toList();
  }

  /// Pobierz lokalizacje bez wymagań
  Future<List<DisposalLocation>> getLocationsWithoutRequirements() async {
    await loadLocations();
    return _locations
        .where(
          (location) =>
              !(location.notes?.toLowerCase().contains('wymagane') ?? false),
        )
        .toList();
  }

  /// Pobierz lokalizacje z limitami
  Future<List<DisposalLocation>> getLocationsWithLimits() async {
    await loadLocations();
    return _locations
        .where(
          (location) =>
              location.notes?.toLowerCase().contains('limit') ?? false,
        )
        .toList();
  }

  /// Pobierz lokalizacje bez limitów
  Future<List<DisposalLocation>> getLocationsWithoutLimits() async {
    await loadLocations();
    return _locations
        .where(
          (location) =>
              !(location.notes?.toLowerCase().contains('limit') ?? false),
        )
        .toList();
  }
}
