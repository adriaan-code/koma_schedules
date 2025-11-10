import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/address.dart';

class LocationHistoryService {
  static const String _key = 'recent_locations';
  static const String _favoritesKey = 'favorite_locations';
  static const int _maxLocations = 5; // Maksymalnie 5 ostatnich lokalizacji

  /// Zapisuje lokalizację jako ostatnią używaną
  static Future<void> saveRecentLocation(Address address) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recentLocations = await getRecentLocations();

      // Usuń duplikaty - jeśli ta lokalizacja już istnieje, usuń ją z listy
      recentLocations.removeWhere(
        (location) =>
            location.street == address.street &&
            location.city == address.city &&
            location.prefix == address.prefix &&
            location.propertyNumber == address.propertyNumber,
      );

      // Dodaj nową lokalizację na początku listy
      recentLocations.insert(0, address);

      // Ogranicz do maksymalnej liczby lokalizacji
      if (recentLocations.length > _maxLocations) {
        recentLocations.removeRange(_maxLocations, recentLocations.length);
      }

      // Zapisz do SharedPreferences
      final locationsJson = recentLocations
          .map((location) => location.toJson())
          .toList();
      await prefs.setString(_key, jsonEncode(locationsJson));

      debugPrint('Zapisano ostatnią lokalizację: ${address.fullAddress}');
    } catch (e) {
      debugPrint('Błąd zapisywania ostatniej lokalizacji: $e');
    }
  }

  /// Pobiera listę ostatnich lokalizacji
  static Future<List<Address>> getRecentLocations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locationsJson = prefs.getString(_key);

      if (locationsJson == null) {
        return [];
      }

      final List<dynamic> locationsList =
          jsonDecode(locationsJson) as List<dynamic>;
      return locationsList
          .map((json) => Address.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Błąd odczytywania ostatnich lokalizacji: $e');
      return [];
    }
  }

  /// Usuwa konkretną lokalizację z historii
  static Future<void> removeLocation(Address address) async {
    try {
      final recentLocations = await getRecentLocations();
      recentLocations.removeWhere(
        (location) =>
            location.street == address.street &&
            location.city == address.city &&
            location.prefix == address.prefix &&
            location.propertyNumber == address.propertyNumber,
      );

      final prefs = await SharedPreferences.getInstance();
      final locationsJson = recentLocations
          .map((location) => location.toJson())
          .toList();
      await prefs.setString(_key, jsonEncode(locationsJson));

      debugPrint('Usunięto lokalizację z historii: ${address.fullAddress}');
    } catch (e) {
      debugPrint('Błąd usuwania lokalizacji z historii: $e');
    }
  }

  /// Czyści całą historię lokalizacji
  static Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);
      debugPrint('Wyczyszczono historię lokalizacji');
    } catch (e) {
      debugPrint('Błąd czyszczenia historii lokalizacji: $e');
    }
  }

  /// Dodaje lokalizację do ulubionych
  static Future<void> addToFavorites(Address address) async {
    try {
      final favorites = await getFavorites();

      // Sprawdź czy już nie jest w ulubionych
      final exists = favorites.any(
        (fav) =>
            fav.street == address.street &&
            fav.city == address.city &&
            fav.prefix == address.prefix &&
            fav.propertyNumber == address.propertyNumber,
      );

      if (!exists) {
        // Utwórz nowy adres z isFavorite = true
        final favoriteAddress = Address(
          street: address.street,
          city: address.city,
          postalCode: address.postalCode,
          isFavorite: true,
          prefix: address.prefix,
          propertyNumber: address.propertyNumber,
        );

        favorites.add(favoriteAddress);

        final prefs = await SharedPreferences.getInstance();
        final favoritesJson = favorites
            .map((location) => location.toJson())
            .toList();
        await prefs.setString(_favoritesKey, jsonEncode(favoritesJson));

        debugPrint('Dodano do ulubionych: ${address.fullAddress}');
      }
    } catch (e) {
      debugPrint('Błąd dodawania do ulubionych: $e');
    }
  }

  /// Usuwa lokalizację z ulubionych
  static Future<void> removeFromFavorites(Address address) async {
    try {
      final favorites = await getFavorites();
      favorites.removeWhere(
        (fav) =>
            fav.street == address.street &&
            fav.city == address.city &&
            fav.prefix == address.prefix &&
            fav.propertyNumber == address.propertyNumber,
      );

      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = favorites
          .map((location) => location.toJson())
          .toList();
      await prefs.setString(_favoritesKey, jsonEncode(favoritesJson));

      debugPrint('Usunięto z ulubionych: ${address.fullAddress}');
    } catch (e) {
      debugPrint('Błąd usuwania z ulubionych: $e');
    }
  }

  /// Pobiera listę ulubionych lokalizacji
  static Future<List<Address>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getString(_favoritesKey);

      if (favoritesJson == null) {
        return [];
      }

      final List<dynamic> favoritesList =
          jsonDecode(favoritesJson) as List<dynamic>;
      return favoritesList
          .map((json) => Address.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Błąd odczytywania ulubionych: $e');
      return [];
    }
  }

  /// Sprawdza czy lokalizacja jest w ulubionych
  static Future<bool> isFavorite(Address address) async {
    try {
      final favorites = await getFavorites();
      return favorites.any(
        (fav) =>
            fav.street == address.street &&
            fav.city == address.city &&
            fav.prefix == address.prefix &&
            fav.propertyNumber == address.propertyNumber,
      );
    } catch (e) {
      debugPrint('Błąd sprawdzania ulubionych: $e');
      return false;
    }
  }
}
