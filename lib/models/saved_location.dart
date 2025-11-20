import 'package:flutter/foundation.dart';
import 'address.dart';

/// Model reprezentujący zapisaną lokalizację użytkownika dla przypomnień
@immutable
class SavedLocation {
  const SavedLocation({
    required this.id,
    required this.address,
    required this.name,
    this.isEnabled = true,
  });

  /// Tworzy SavedLocation z Map (JSON)
  factory SavedLocation.fromJson(Map<String, dynamic> json) {
    return SavedLocation(
      id: json['id'] as String,
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      name: json['name'] as String? ?? '',
      isEnabled: json['isEnabled'] as bool? ?? true,
    );
  }

  final String id;
  final Address address;
  final String name; // Nazwa lokalizacji (np. "Dom", "Działka", "Biuro")
  final bool isEnabled; // Czy powiadomienia dla tej lokalizacji są włączone

  /// Tworzy kopię z możliwością zmiany wybranych pól
  SavedLocation copyWith({
    String? id,
    Address? address,
    String? name,
    bool? isEnabled,
  }) {
    return SavedLocation(
      id: id ?? this.id,
      address: address ?? this.address,
      name: name ?? this.name,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  /// Konwertuje SavedLocation na Map dla JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address.toJson(),
      'name': name,
      'isEnabled': isEnabled,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SavedLocation &&
        other.id == id &&
        other.address == address &&
        other.name == name &&
        other.isEnabled == isEnabled;
  }

  @override
  int get hashCode {
    return Object.hash(id, address, name, isEnabled);
  }

  @override
  String toString() {
    return 'SavedLocation(id: $id, name: $name, address: $address, isEnabled: $isEnabled)';
  }
}

