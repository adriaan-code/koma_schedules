import 'dart:math';

/// Model reprezentujący lokalizację utylizacji odpadów
class DisposalLocation {
  const DisposalLocation({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.phone,
    required this.email,
    required this.website,
    required this.coordinates,
    required this.openingHours,
    required this.acceptedWasteTypes,
    required this.services,
    this.notes,
  });

  factory DisposalLocation.fromJson(Map<String, dynamic> json) {
    return DisposalLocation(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      website: json['website'] as String,
      coordinates: Coordinates.fromJson(
        json['coordinates'] as Map<String, dynamic>,
      ),
      openingHours: Map<String, String>.from(json['openingHours'] as Map),
      acceptedWasteTypes: List<String>.from(json['acceptedWasteTypes'] as List),
      services: List<String>.from(json['services'] as List),
      notes: json['notes'] as String?,
    );
  }
  final String id;
  final String name;
  final String type;
  final String address;
  final String phone;
  final String email;
  final String website;
  final Coordinates coordinates;
  final Map<String, String> openingHours;
  final List<String> acceptedWasteTypes;
  final List<String> services;
  final String? notes;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'address': address,
      'phone': phone,
      'email': email,
      'website': website,
      'coordinates': coordinates.toJson(),
      'openingHours': openingHours,
      'acceptedWasteTypes': acceptedWasteTypes,
      'services': services,
      'notes': notes,
    };
  }

  /// Sprawdź czy lokalizacja jest otwarta w danym dniu
  bool isOpenOnDay(String day) {
    final hours = openingHours[day.toLowerCase()];
    if (hours == null || hours == 'Zamknięte') return false;
    if (hours == '24/7') return true;

    // Prosta logika sprawdzania godzin (można rozszerzyć)
    return true; // Dla uproszczenia zwracamy true
  }

  /// Sprawdź czy lokalizacja przyjmuje dany typ odpadu
  bool acceptsWasteType(String wasteType) {
    return acceptedWasteTypes.contains(wasteType.toLowerCase());
  }

  /// Pobierz godziny otwarcia dla danego dnia
  String getOpeningHoursForDay(String day) {
    return openingHours[day.toLowerCase()] ?? 'Zamknięte';
  }
}

/// Model reprezentujący współrzędne geograficzne
class Coordinates {
  const Coordinates({required this.latitude, required this.longitude});

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }
  final double latitude;
  final double longitude;

  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude};
  }

  /// Oblicz odległość do innej lokalizacji (w kilometrach)
  double distanceTo(Coordinates other) {
    const double earthRadius = 6371; // Promień Ziemi w km

    final double lat1Rad = latitude * (3.14159265359 / 180);
    final double lat2Rad = other.latitude * (3.14159265359 / 180);
    final double deltaLatRad =
        (other.latitude - latitude) * (3.14159265359 / 180);
    final double deltaLonRad =
        (other.longitude - longitude) * (3.14159265359 / 180);

    final double a =
        sin(deltaLatRad / 2) * sin(deltaLatRad / 2) +
        cos(lat1Rad) *
            cos(lat2Rad) *
            sin(deltaLonRad / 2) *
            sin(deltaLonRad / 2);
    final double c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }
}

/// Typy lokalizacji utylizacji
enum DisposalLocationType {
  pszok('PSZOK'),
  apteka('Apteka'),
  sklepRtvAgd('Sklep RTV/AGD'),
  organizacjaCharytatywna('Organizacja charytatywna'),
  warsztatSamochodowy('Warsztat samochodowy'),
  biblioteka('Biblioteka'),
  kontener('Kontener'),
  punktZbiorki('Punkt zbiórki'),
  sklep('Sklep'),
  inne('Inne');

  const DisposalLocationType(this.displayName);
  final String displayName;

  static DisposalLocationType fromString(String value) {
    return DisposalLocationType.values.firstWhere(
      (type) => type.name == value.toLowerCase(),
      orElse: () => DisposalLocationType.inne,
    );
  }
}
