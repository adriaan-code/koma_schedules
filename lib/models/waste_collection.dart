import 'package:flutter/foundation.dart';
import 'waste_type.dart';

/// Model reprezentujący zbiórkę odpadów
@immutable
class WasteCollection {
  const WasteCollection({
    required this.day,
    required this.month,
    required this.wasteType,
    required this.startTime,
    required this.endTime,
    required this.dayOfWeek,
    required this.originalTypeName,
  });

  final int day;
  final String month;
  final WasteType wasteType;
  final String startTime;
  final String endTime;
  final String dayOfWeek;
  final String originalTypeName; // Oryginalna nazwa frakcji z API

  /// Tworzy kopię z możliwością zmiany wybranych pól
  WasteCollection copyWith({
    int? day,
    String? month,
    WasteType? wasteType,
    String? startTime,
    String? endTime,
    String? dayOfWeek,
    String? originalTypeName,
  }) {
    return WasteCollection(
      day: day ?? this.day,
      month: month ?? this.month,
      wasteType: wasteType ?? this.wasteType,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      originalTypeName: originalTypeName ?? this.originalTypeName,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WasteCollection &&
        other.day == day &&
        other.month == month &&
        other.wasteType == wasteType &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.dayOfWeek == dayOfWeek &&
        other.originalTypeName == originalTypeName;
  }

  @override
  int get hashCode {
    return Object.hash(
      day,
      month,
      wasteType,
      startTime,
      endTime,
      dayOfWeek,
      originalTypeName,
    );
  }

  @override
  String toString() {
    return 'WasteCollection(day: $day, month: $month, wasteType: $wasteType, startTime: $startTime, endTime: $endTime, dayOfWeek: $dayOfWeek, originalTypeName: $originalTypeName)';
  }
}
