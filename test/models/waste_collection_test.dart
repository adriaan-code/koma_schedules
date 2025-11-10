import 'package:flutter_test/flutter_test.dart';
import 'package:koma_app/models/waste_collection.dart';
import 'package:koma_app/models/waste_type.dart';

void main() {
  group('WasteCollection Model Tests', () {
    test('should create WasteCollection with all fields', () {
      const collection = WasteCollection(
        day: 15,
        month: 'Styczeń',
        wasteType: WasteType.mixed,
        startTime: '06:00',
        endTime: '20:00',
        dayOfWeek: 'Poniedziałek',
        originalTypeName: 'ZMIESZANE',
      );

      expect(collection.day, 15);
      expect(collection.month, 'Styczeń');
      expect(collection.wasteType, WasteType.mixed);
      expect(collection.startTime, '06:00');
      expect(collection.endTime, '20:00');
      expect(collection.dayOfWeek, 'Poniedziałek');
      expect(collection.originalTypeName, 'ZMIESZANE');
    });

    test('should create copy with modified fields', () {
      const original = WasteCollection(
        day: 15,
        month: 'Styczeń',
        wasteType: WasteType.mixed,
        startTime: '06:00',
        endTime: '20:00',
        dayOfWeek: 'Poniedziałek',
        originalTypeName: 'ZMIESZANE',
      );

      final copy = original.copyWith(day: 20, wasteType: WasteType.paper);

      expect(copy.day, 20);
      expect(copy.wasteType, WasteType.paper);
      expect(copy.month, 'Styczeń'); // unchanged
      expect(copy.startTime, '06:00'); // unchanged
    });

    test('should compare collections correctly', () {
      const collection1 = WasteCollection(
        day: 15,
        month: 'Styczeń',
        wasteType: WasteType.mixed,
        startTime: '06:00',
        endTime: '20:00',
        dayOfWeek: 'Poniedziałek',
        originalTypeName: 'ZMIESZANE',
      );

      const collection2 = WasteCollection(
        day: 15,
        month: 'Styczeń',
        wasteType: WasteType.mixed,
        startTime: '06:00',
        endTime: '20:00',
        dayOfWeek: 'Poniedziałek',
        originalTypeName: 'ZMIESZANE',
      );

      const collection3 = WasteCollection(
        day: 20,
        month: 'Styczeń',
        wasteType: WasteType.mixed,
        startTime: '06:00',
        endTime: '20:00',
        dayOfWeek: 'Czwartek',
        originalTypeName: 'ZMIESZANE',
      );

      expect(collection1, collection2);
      expect(collection1, isNot(collection3));
    });

    test('should have same hashCode for equal collections', () {
      const collection1 = WasteCollection(
        day: 15,
        month: 'Styczeń',
        wasteType: WasteType.mixed,
        startTime: '06:00',
        endTime: '20:00',
        dayOfWeek: 'Poniedziałek',
        originalTypeName: 'ZMIESZANE',
      );

      const collection2 = WasteCollection(
        day: 15,
        month: 'Styczeń',
        wasteType: WasteType.mixed,
        startTime: '06:00',
        endTime: '20:00',
        dayOfWeek: 'Poniedziałek',
        originalTypeName: 'ZMIESZANE',
      );

      expect(collection1.hashCode, collection2.hashCode);
    });
  });
}
