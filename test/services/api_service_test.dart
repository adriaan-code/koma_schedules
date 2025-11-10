import 'package:flutter_test/flutter_test.dart';
import 'package:koma_app/models/api_models.dart';

void main() {
  group('ApiWasteSearchResult Tests', () {
    test('should create ApiWasteSearchResult from JSON', () {
      final json = {
        'id': '123',
        'waste_name': 'Plastik',
        'main_container': 'Żółty',
        'secondary_container': 'Niebieski',
        'waste_group': 'Surowce',
      };

      final result = ApiWasteSearchResult.fromJson(json);

      expect(result.id, '123');
      expect(result.waste_name, 'Plastik');
      expect(result.main_container, 'Żółty');
      expect(result.secondary_container, 'Niebieski');
      expect(result.waste_group, 'Surowce');
    });

    test('should handle missing fields with default values', () {
      final json = <String, dynamic>{};

      final result = ApiWasteSearchResult.fromJson(json);

      expect(result.id, '');
      expect(result.waste_name, '');
      expect(result.main_container, '');
      expect(result.secondary_container, '');
      expect(result.waste_group, '');
    });

    test('should convert ApiWasteSearchResult to JSON', () {
      const result = ApiWasteSearchResult(
        id: '123',
        waste_name: 'Plastik',
        main_container: 'Żółty',
        secondary_container: 'Niebieski',
        waste_group: 'Surowce',
      );

      final json = result.toJson();

      expect(json['id'], '123');
      expect(json['waste_name'], 'Plastik');
      expect(json['main_container'], 'Żółty');
      expect(json['secondary_container'], 'Niebieski');
      expect(json['waste_group'], 'Surowce');
    });
  });

  group('ApiAddress Tests', () {
    test('should create ApiAddress from JSON', () {
      final json = {
        'street': 'Kwiatowa',
        'city': 'Warszawa',
        'postalCode': '00-001',
        'houseNumber': '10',
        'apartmentNumber': '5',
      };

      final address = ApiAddress.fromJson(json);

      expect(address.street, 'Kwiatowa');
      expect(address.city, 'Warszawa');
      expect(address.postalCode, '00-001');
      expect(address.houseNumber, '10');
      expect(address.apartmentNumber, '5');
    });

    test('should handle optional fields', () {
      final json = {
        'street': 'Kwiatowa',
        'city': 'Warszawa',
        'postalCode': '00-001',
      };

      final address = ApiAddress.fromJson(json);

      expect(address.houseNumber, null);
      expect(address.apartmentNumber, null);
    });
  });

  group('ApiWasteCollection Tests', () {
    test('should create ApiWasteCollection from JSON', () {
      final json = {
        'data': '2025-10-21T00:00:00.000Z',
        'typ': 'Plastik',
      };

      final collection = ApiWasteCollection.fromJson(json);

      expect(collection.data, DateTime.parse('2025-10-21T00:00:00.000Z'));
      expect(collection.typ, 'Plastik');
    });

    test('should convert ApiWasteCollection to JSON', () {
      final collection = ApiWasteCollection(
        data: DateTime.parse('2025-10-21T00:00:00.000Z'),
        typ: 'Plastik',
      );

      final json = collection.toJson();

      expect(json['data'], '2025-10-21T00:00:00.000Z');
      expect(json['typ'], 'Plastik');
    });
  });

  group('ApiLocation Tests', () {
    test('should create ApiLocation from JSON', () {
      final json = {
        'gmina': 'Warszawa',
        'miejscowosc': 'Mokotów',
      };

      final location = ApiLocation.fromJson(json);

      expect(location.gmina, 'Warszawa');
      expect(location.miejscowosc, 'Mokotów');
    });

    test('should convert ApiLocation to JSON', () {
      const location = ApiLocation(
        gmina: 'Warszawa',
        miejscowosc: 'Mokotów',
      );

      final json = location.toJson();

      expect(json['gmina'], 'Warszawa');
      expect(json['miejscowosc'], 'Mokotów');
    });
  });

  group('ApiProperty Tests', () {
    test('should create ApiProperty from JSON', () {
      final json = {
        'prefix': 'W',
        'numer_posesji': '123',
        'typ_nieruchomosci': 'Dom',
        'miejscowosc': 'Warszawa',
        'ulica': 'Kwiatowa',
        'numer_domu': '10',
        'nazwa': 'Budynek A',
        'url': 'https://example.com',
      };

      final property = ApiProperty.fromJson(json);

      expect(property.prefix, 'W');
      expect(property.numer_posesji, '123');
      expect(property.typ_nieruchomosci, 'Dom');
      expect(property.miejscowosc, 'Warszawa');
      expect(property.ulica, 'Kwiatowa');
      expect(property.numer_domu, '10');
      expect(property.nazwa, 'Budynek A');
      expect(property.url, 'https://example.com');
      expect(property.fullNumber, '10');
    });

    test('should handle missing optional nazwa', () {
      final json = {
        'prefix': 'W',
        'numer_posesji': '123',
        'typ_nieruchomosci': 'Dom',
        'miejscowosc': 'Warszawa',
        'ulica': 'Kwiatowa',
        'numer_domu': '10',
        'url': 'https://example.com',
      };

      final property = ApiProperty.fromJson(json);

      expect(property.nazwa, null);
    });
  });
}

