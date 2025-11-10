import 'package:flutter/foundation.dart';

/// Model reprezentujący adres użytkownika
@immutable
class Address {
  const Address({
    required this.street,
    required this.city,
    required this.postalCode,
    this.isFavorite = false,
    this.prefix,
    this.propertyNumber,
  });

  /// Tworzy Address z Map (JSON)
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] as String? ?? '',
      city: json['city'] as String? ?? '',
      postalCode: json['postalCode'] as String? ?? '',
      isFavorite: json['isFavorite'] as bool? ?? false,
      prefix: json['prefix'] as String?,
      propertyNumber: json['propertyNumber'] as String?,
    );
  }

  final String street;
  final String city;
  final String postalCode;
  final bool isFavorite;
  final String? prefix;
  final String? propertyNumber;

  /// Pełny adres w formacie czytelnym dla użytkownika
  String get fullAddress => '$street, $postalCode $city';

  /// Tworzy kopię z możliwością zmiany wybranych pól
  Address copyWith({
    String? street,
    String? city,
    String? postalCode,
    bool? isFavorite,
    String? prefix,
    String? propertyNumber,
  }) {
    return Address(
      street: street ?? this.street,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      isFavorite: isFavorite ?? this.isFavorite,
      prefix: prefix ?? this.prefix,
      propertyNumber: propertyNumber ?? this.propertyNumber,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Address &&
        other.street == street &&
        other.city == city &&
        other.postalCode == postalCode &&
        other.isFavorite == isFavorite &&
        other.prefix == prefix &&
        other.propertyNumber == propertyNumber;
  }

  @override
  int get hashCode {
    return Object.hash(
      street,
      city,
      postalCode,
      isFavorite,
      prefix,
      propertyNumber,
    );
  }

  @override
  String toString() {
    return 'Address(street: $street, city: $city, postalCode: $postalCode, isFavorite: $isFavorite, prefix: $prefix, propertyNumber: $propertyNumber)';
  }

  /// Konwertuje Address na Map dla JSON
  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'postalCode': postalCode,
      'isFavorite': isFavorite,
      if (prefix != null) 'prefix': prefix,
      if (propertyNumber != null) 'propertyNumber': propertyNumber,
    };
  }
}
