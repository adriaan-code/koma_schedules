import 'package:flutter_test/flutter_test.dart';
import 'package:koma_app/models/address.dart';

void main() {
  group('Address Model Tests', () {
    test('should create Address with all fields', () {
      const address = Address(
        street: 'Główna 1',
        city: 'Ełk',
        postalCode: '19-300',
        isFavorite: true,
        prefix: 'E',
        propertyNumber: 'E000251',
      );

      expect(address.street, 'Główna 1');
      expect(address.city, 'Ełk');
      expect(address.postalCode, '19-300');
      expect(address.isFavorite, true);
      expect(address.prefix, 'E');
      expect(address.propertyNumber, 'E000251');
    });

    test('should generate correct fullAddress', () {
      const address = Address(
        street: 'Główna 1',
        city: 'Ełk',
        postalCode: '19-300',
      );

      expect(address.fullAddress, 'Główna 1, 19-300 Ełk');
    });

    test('should create Address from JSON', () {
      final json = {
        'street': 'Główna 1',
        'city': 'Ełk',
        'postalCode': '19-300',
        'isFavorite': true,
        'prefix': 'E',
        'propertyNumber': 'E000251',
      };

      final address = Address.fromJson(json);

      expect(address.street, 'Główna 1');
      expect(address.city, 'Ełk');
      expect(address.isFavorite, true);
    });

    test('should convert Address to JSON', () {
      const address = Address(
        street: 'Główna 1',
        city: 'Ełk',
        postalCode: '19-300',
        isFavorite: false,
        prefix: 'E',
        propertyNumber: 'E000251',
      );

      final json = address.toJson();

      expect(json['street'], 'Główna 1');
      expect(json['city'], 'Ełk');
      expect(json['postalCode'], '19-300');
      expect(json['isFavorite'], false);
      expect(json['prefix'], 'E');
      expect(json['propertyNumber'], 'E000251');
    });

    test('should create copy with modified fields', () {
      const original = Address(
        street: 'Główna 1',
        city: 'Ełk',
        postalCode: '19-300',
      );

      final copy = original.copyWith(street: 'Nowa 2', isFavorite: true);

      expect(copy.street, 'Nowa 2');
      expect(copy.city, 'Ełk'); // unchanged
      expect(copy.postalCode, '19-300'); // unchanged
      expect(copy.isFavorite, true);
    });

    test('should compare addresses correctly', () {
      const address1 = Address(
        street: 'Główna 1',
        city: 'Ełk',
        postalCode: '19-300',
      );

      const address2 = Address(
        street: 'Główna 1',
        city: 'Ełk',
        postalCode: '19-300',
      );

      const address3 = Address(
        street: 'Nowa 2',
        city: 'Ełk',
        postalCode: '19-300',
      );

      expect(address1, address2);
      expect(address1, isNot(address3));
    });

    test('should have same hashCode for equal addresses', () {
      const address1 = Address(
        street: 'Główna 1',
        city: 'Ełk',
        postalCode: '19-300',
      );

      const address2 = Address(
        street: 'Główna 1',
        city: 'Ełk',
        postalCode: '19-300',
      );

      expect(address1.hashCode, address2.hashCode);
    });
  });
}
