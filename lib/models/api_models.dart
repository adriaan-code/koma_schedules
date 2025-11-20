// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'waste_type.dart';

/// Model dla wyszukiwania odpadów
@immutable
class ApiWasteSearchResult {
  const ApiWasteSearchResult({
    required this.id,
    required this.waste_name,
    required this.main_container,
    required this.secondary_container,
    required this.waste_group,
  });

  factory ApiWasteSearchResult.fromJson(Map<String, dynamic> json) {
    return ApiWasteSearchResult(
      id: json['id'] as String? ?? '',
      waste_name: json['waste_name'] as String? ?? '',
      main_container: json['main_container'] as String? ?? '',
      secondary_container: json['secondary_container'] as String? ?? '',
      waste_group: json['waste_group'] as String? ?? '',
    );
  }

  final String id;
  final String waste_name;
  final String main_container;
  final String secondary_container;
  final String waste_group;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'waste_name': waste_name,
      'main_container': main_container,
      'secondary_container': secondary_container,
      'waste_group': waste_group,
    };
  }

  /// Mapuje waste_group na WasteType dla kolorów
  WasteType get wasteType {
    final group = waste_group.toLowerCase();
    
    // Green waste variants
    if (['odpady zielone', 'zielone', 'rośliny', 'rosliny', 'choinki', 'green', 'green waste'].contains(group)) {
      return WasteType.green;
    }
    
    // Bulky waste variants
    if (['gabaryty', 'bulky'].contains(group)) {
      return WasteType.bulky;
    }
    
    // Elektro waste
    if (['elektro'].contains(group)) {
      return WasteType.elektro;
    }
    
    // Opony waste
    if (['opony'].contains(group)) {
      return WasteType.opony;
    }
    
    // Mixed waste variants
    if (['zmieszane', 'mixed', 'inne'].contains(group)) {
      return WasteType.mixed;
    }
    
    // Direct mappings
    switch (group) {
      case 'papier':
      case 'paper':
        return WasteType.paper;
      case 'szkło':
      case 'glass':
        return WasteType.glass;
      case 'metale i tworzywa sztuczne':
      case 'metal':
        return WasteType.metal;
      case 'popiół':
      case 'ash':
        return WasteType.ash;
      case 'bio':
      case 'biodegradowalne':
        return WasteType.bio;
      default:
        return WasteType.mixed;
    }
  }

  /// Mapuje main_container na WasteType dla kolorów i obrazków
  /// Łączy waste_group z main_container - waste_group ma priorytet, ale main_container może go nadpisać
  /// dla specjalnych przypadków (elektroodpady, PSZOK, itp.)
  WasteType get containerWasteType {
    final group = waste_group.toLowerCase().trim();
    final container = main_container.toLowerCase().trim();
    
    // Specjalne miejsca zbiórki - zawsze mają priorytet niezależnie od waste_group
    if (container.contains('punkt zbiórki elektroodpadów') || 
        container.contains('punkt zbiorki elektroodpadow') ||
        container.contains('elektroodpad')) {
      return WasteType.elektro;
    }
    
    if (container.contains('pojemnik na baterie') || 
        container.contains('baterie i akumulatory')) {
      return WasteType.elektro; // Baterie są częścią elektroodpadów
    }
    
    // PSZOK - używa waste_group, bo przyjmuje różne odpady
    if (container.contains('pszok')) {
      return wasteType;
    }
    
    // Jeśli waste_group jest konkretny typ (nie "zmieszane" ani "inne"),
    // użyj go jako podstawy
    if (group.isNotEmpty && 
        group != 'zmieszane' && 
        group != 'mixed' && 
        group != 'inne' &&
        group != 'other') {
      // Sprawdź czy main_container potwierdza waste_group przez kolor pojemnika
      // Jeśli tak, użyj waste_group
      if (group == 'papier' || group == 'paper') {
        if (container.contains('pojemnik niebieski') || container.isEmpty) {
          return WasteType.paper;
        }
      }
      if (group == 'szkło' || group == 'glass') {
        if (container.contains('pojemnik zielony') || container.isEmpty) {
          return WasteType.glass;
        }
      }
      if (group == 'metale i tworzywa sztuczne' || group == 'metal') {
        if (container.contains('pojemnik żółty') || container.contains('pojemnik zolty') || container.isEmpty) {
          return WasteType.metal;
        }
      }
      if (group == 'bio' || group == 'biodegradowalne') {
        if (container.contains('pojemnik brązowy') || container.contains('pojemnik brazowy') || container.isEmpty) {
          return WasteType.bio;
        }
      }
      
      // Dla pozostałych konkretnych typów zawsze używaj waste_group
      return wasteType;
    }
    
    // Jeśli waste_group jest "zmieszane" lub "inne", sprawdź main_container
    // Pojemniki kolorowe - bezpośrednie mapowanie
    if (container.contains('pojemnik żółty') || container.contains('pojemnik zolty')) {
      return WasteType.metal; // Żółty = metale i tworzywa sztuczne
    }
    
    if (container.contains('pojemnik brązowy') || container.contains('pojemnik brazowy')) {
      return WasteType.bio; // Brązowy = bioodpady
    }
    
    if (container.contains('pojemnik czarny')) {
      return WasteType.mixed; // Czarny = zmieszane
    }
    
    if (container.contains('pojemnik niebieski')) {
      return WasteType.paper; // Niebieski = papier
    }
    
    if (container.contains('pojemnik zielony')) {
      return WasteType.green; // Zielony = odpady zielone
    }
    
    if (container.contains('apteka')) {
      // Odpady medyczne - możemy użyć specjalnego koloru lub mixed
      return WasteType.mixed;
    }
    
    if (container.contains('firma specjalistyczna')) {
      // Odpady specjalne (np. azbest) - możemy użyć specjalnego koloru
      return WasteType.mixed;
    }
    
    // Jeśli nie znaleziono dopasowania, użyj wasteType (waste_group)
    return wasteType;
  }
  
  /// Zwraca kolor na podstawie main_container (lub waste_group jako fallback)
  Color get containerColor => containerWasteType.color;
}

@immutable
class ApiAddress {
  const ApiAddress({
    required this.street,
    required this.city,
    required this.postalCode,
    this.houseNumber,
    this.apartmentNumber,
  });

  factory ApiAddress.fromJson(Map<String, dynamic> json) {
    return ApiAddress(
      street: json['street'] as String? ?? '',
      city: json['city'] as String? ?? '',
      postalCode: json['postalCode'] as String? ?? '',
      houseNumber: json['houseNumber'] as String?,
      apartmentNumber: json['apartmentNumber'] as String?,
    );
  }

  final String street;
  final String city;
  final String postalCode;
  final String? houseNumber;
  final String? apartmentNumber;

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'postalCode': postalCode,
      'houseNumber': houseNumber,
      'apartmentNumber': apartmentNumber,
    };
  }
}

@immutable
class ApiWasteCollection {
  const ApiWasteCollection({required this.data, required this.typ});

  factory ApiWasteCollection.fromJson(Map<String, dynamic> json) {
    return ApiWasteCollection(
      data: DateTime.parse(json['data'] as String),
      typ: json['typ'] as String? ?? '',
    );
  }

  final DateTime data;
  final String typ;

  Map<String, dynamic> toJson() {
    return {'data': data.toIso8601String(), 'typ': typ};
  }
}

@immutable
class ApiPosesja {
  const ApiPosesja({
    required this.prefix,
    required this.numer,
    required this.gmina,
    required this.miejscowosc,
    required this.ulica,
  });

  factory ApiPosesja.fromJson(Map<String, dynamic> json) {
    return ApiPosesja(
      prefix: json['prefix'] as String? ?? '',
      numer: json['numer'] as String? ?? '',
      gmina: json['gmina'] as String? ?? '',
      miejscowosc: json['miejscowosc'] as String? ?? '',
      ulica: json['ulica'] as String? ?? '',
    );
  }

  final String prefix;
  final String numer;
  final String gmina;
  final String miejscowosc;
  final String ulica;

  Map<String, dynamic> toJson() {
    return {
      'prefix': prefix,
      'numer': numer,
      'gmina': gmina,
      'miejscowosc': miejscowosc,
      'ulica': ulica,
    };
  }
}

class ApiScheduleResponse {
  ApiScheduleResponse({
    this.nazwa,
    required this.rok,
    required this.miesiacOd,
    required this.miesiacDo,
    required this.frakcje,
    required this.odbior,
  });

  factory ApiScheduleResponse.fromJson(Map<String, dynamic> json) {
    return ApiScheduleResponse(
      nazwa: json['nazwa'] as String?,
      rok: json['rok'] as String? ?? '',
      miesiacOd: json['miesiac_od'] as int? ?? 1,
      miesiacDo: json['miesiac_do'] as int? ?? 12,
      frakcje: Map<String, String>.from(
        json['frakcje'] as Map<dynamic, dynamic>? ?? {},
      ),
      odbior:
          (json['odbior'] as List<dynamic>?)
              ?.map(
                (item) =>
                    ApiWasteCollection.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
  final String? nazwa;
  final String rok;
  final int miesiacOd;
  final int miesiacDo;
  final Map<String, String> frakcje;
  final List<ApiWasteCollection> odbior;

  Map<String, dynamic> toJson() {
    return {
      'nazwa': nazwa,
      'rok': rok,
      'miesiac_od': miesiacOd,
      'miesiac_do': miesiacDo,
      'frakcje': frakcje,
      'odbior': odbior.map((item) => item.toJson()).toList(),
    };
  }
}

class ApiErrorResponse {
  ApiErrorResponse({required this.message, this.code, this.details});

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) {
    return ApiErrorResponse(
      message: json['message'] as String? ?? '',
      code: json['code'] as String?,
      details: json['details'] as Map<String, dynamic>?,
    );
  }
  final String message;
  final String? code;
  final Map<String, dynamic>? details;

  Map<String, dynamic> toJson() {
    return {'message': message, 'code': code, 'details': details};
  }
}

// Modele dla API KOMA sektorów
@immutable
class ApiLocation {
  const ApiLocation({required this.gmina, required this.miejscowosc});

  factory ApiLocation.fromJson(Map<String, dynamic> json) {
    return ApiLocation(
      gmina: json['gmina'] as String? ?? '',
      miejscowosc: json['miejscowosc'] as String? ?? '',
    );
  }

  final String gmina;
  final String miejscowosc;

  Map<String, dynamic> toJson() {
    return {'gmina': gmina, 'miejscowosc': miejscowosc};
  }
}

class ApiSector {
  ApiSector({required this.name, required this.locations});

  factory ApiSector.fromJson(Map<String, dynamic> json) {
    return ApiSector(
      name: json['name'] as String? ?? '',
      locations:
          (json['locations'] as List<dynamic>?)
              ?.map(
                (item) => ApiLocation.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
  final String name;
  final List<ApiLocation> locations;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'locations': locations.map((item) => item.toJson()).toList(),
    };
  }
}

class ApiSectorsResponse {
  ApiSectorsResponse({required this.sectors});

  factory ApiSectorsResponse.fromJson(Map<String, dynamic> json) {
    final Map<String, Map<String, List<ApiLocation>>> sectors = {};

    json.forEach((sectorName, sectorData) {
      if (sectorData is Map<String, dynamic>) {
        final Map<String, List<ApiLocation>> prefiksy = {};

        // Iteruj przez wszystkie prefiksy w sektorze
        sectorData.forEach((prefiksName, locationsData) {
          if (locationsData is List) {
            final List<ApiLocation> locations = [];
            for (final locationData in locationsData) {
              if (locationData is Map<String, dynamic>) {
                locations.add(ApiLocation.fromJson(locationData));
              }
            }
            prefiksy[prefiksName] = locations;
          }
        });

        sectors[sectorName] = prefiksy;
      }
    });

    return ApiSectorsResponse(sectors: sectors);
  }
  final Map<String, Map<String, List<ApiLocation>>> sectors;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    sectors.forEach((sectorName, prefiksy) {
      result[sectorName] = prefiksy.map((prefiksName, locations) {
        return MapEntry(
          prefiksName,
          locations.map((location) => location.toJson()).toList(),
        );
      });
    });
    return result;
  }

  // Pobiera wszystkie miejscowości jako listę
  List<ApiLocation> getAllLocations() {
    final List<ApiLocation> allLocations = [];
    sectors.forEach((sectorName, prefiksy) {
      prefiksy.forEach((prefiksName, locations) {
        allLocations.addAll(locations);
      });
    });
    return allLocations;
  }

  // Wyszukuje miejscowości na podstawie zapytania
  List<ApiLocation> searchLocations(String query) {
    String normalize(String s) {
      final lower = s.toLowerCase();
      // prosta normalizacja PL znaków diakrytycznych
      return lower
          .replaceAll('ą', 'a')
          .replaceAll('ć', 'c')
          .replaceAll('ę', 'e')
          .replaceAll('ł', 'l')
          .replaceAll('ń', 'n')
          .replaceAll('ó', 'o')
          .replaceAll('ś', 's')
          .replaceAll('ż', 'z')
          .replaceAll('ź', 'z');
    }

    final normTokens = normalize(query)
        .split(RegExp(r"\s+"))
        .where((t) => t.isNotEmpty)
        .toList();

    final List<ApiLocation> results = [];

    sectors.forEach((sectorName, prefiksy) {
      prefiksy.forEach((prefiksName, locations) {
        for (final location in locations) {
          final hay = normalize('${location.gmina} ${location.miejscowosc}');
          // dopasowanie jeśli jakikolwiek token występuje w gmina/miejscowosc
          if (normTokens.any((t) => hay.contains(t))) {
            results.add(location);
          }
        }
      });
    });

    return results;
  }
}

@immutable
class ApiStreet {
  const ApiStreet({
    required this.prefix,
    required this.gmina,
    required this.miejscowosc,
    required this.ulica,
  });

  factory ApiStreet.fromJson(Map<String, dynamic> json) {
    return ApiStreet(
      prefix: json['prefix'] as String? ?? '',
      gmina: json['gmina'] as String? ?? '',
      miejscowosc: json['miejscowosc'] as String? ?? '',
      ulica: json['ulica'] as String? ?? '',
    );
  }

  final String prefix;
  final String gmina;
  final String miejscowosc;
  final String ulica;

  Map<String, dynamic> toJson() {
    return {
      'prefix': prefix,
      'gmina': gmina,
      'miejscowosc': miejscowosc,
      'ulica': ulica,
    };
  }
}

class ApiStreetsResponse {
  ApiStreetsResponse({required this.streets});

  factory ApiStreetsResponse.fromJson(List<dynamic> json) {
    final List<ApiStreet> streets = [];

    for (final streetData in json) {
      if (streetData is Map<String, dynamic>) {
        streets.add(ApiStreet.fromJson(streetData));
      }
    }

    return ApiStreetsResponse(streets: streets);
  }
  final List<ApiStreet> streets;

  Map<String, dynamic> toJson() {
    return {'streets': streets.map((street) => street.toJson()).toList()};
  }
}

@immutable
class ApiProperty {
  const ApiProperty({
    required this.prefix,
    required this.numer_posesji,
    required this.typ_nieruchomosci,
    required this.miejscowosc,
    required this.ulica,
    required this.numer_domu,
    this.nazwa,
    required this.url,
  });

  factory ApiProperty.fromJson(Map<String, dynamic> json) {
    return ApiProperty(
      prefix: json['prefix'] as String? ?? '',
      numer_posesji: json['numer_posesji'] as String? ?? '',
      typ_nieruchomosci: json['typ_nieruchomosci'] as String? ?? '',
      miejscowosc: json['miejscowosc'] as String? ?? '',
      ulica: json['ulica'] as String? ?? '',
      numer_domu: json['numer_domu'] as String? ?? '',
      nazwa: json['nazwa'] as String?,
      url: json['url'] as String? ?? '',
    );
  }

  final String prefix;
  final String numer_posesji;
  final String typ_nieruchomosci;
  final String miejscowosc;
  final String ulica;
  final String numer_domu;
  final String? nazwa;
  final String url;

  Map<String, dynamic> toJson() {
    return {
      'prefix': prefix,
      'numer_posesji': numer_posesji,
      'typ_nieruchomosci': typ_nieruchomosci,
      'miejscowosc': miejscowosc,
      'ulica': ulica,
      'numer_domu': numer_domu,
      'nazwa': nazwa,
      'url': url,
    };
  }

  String get fullNumber => numer_domu;
}

class ApiPropertiesResponse {
  ApiPropertiesResponse({required this.properties});

  factory ApiPropertiesResponse.fromJson(Map<String, dynamic> json) {
    final List<ApiProperty> properties = [];

    if (json['properties'] is List) {
      final propertiesList = json['properties'] as List<dynamic>;
      for (final propertyData in propertiesList) {
        if (propertyData is Map<String, dynamic>) {
          properties.add(ApiProperty.fromJson(propertyData));
        }
      }
    }

    return ApiPropertiesResponse(properties: properties);
  }
  final List<ApiProperty> properties;

  Map<String, dynamic> toJson() {
    return {
      'properties': properties.map((property) => property.toJson()).toList(),
    };
  }
}
