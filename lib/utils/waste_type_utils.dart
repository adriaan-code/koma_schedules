import '../l10n/app_localizations.dart';
import '../models/waste_type.dart';

/// Utility functions for waste type localization
class WasteTypeUtils {
  /// Maps WasteType enum to localization key
  static String getWasteTypeKey(WasteType wasteType) {
    switch (wasteType) {
      case WasteType.mixed:
        return 'mixed';
      case WasteType.paper:
        return 'paper';
      case WasteType.glass:
        return 'glass';
      case WasteType.metal:
        return 'plastic'; // API uses "plastic" key for metals and plastics
      case WasteType.bio:
        return 'bio';
      case WasteType.ash:
        return 'ash';
      case WasteType.bulky:
        return 'bulky';
      case WasteType.green:
        return 'green';
      case WasteType.elektro:
        return 'elektro';
      case WasteType.opony:
        return 'opony';
    }
  }

  /// Gets localized waste type name from WasteType enum
  static String getLocalizedWasteTypeName(AppLocalizations l10n, WasteType wasteType) {
    switch (wasteType) {
      case WasteType.mixed:
        return l10n.mixed;
      case WasteType.paper:
        return l10n.paper;
      case WasteType.glass:
        return l10n.glass;
      case WasteType.metal:
        return l10n.plastic; // API uses "plastic" key for metals and plastics
      case WasteType.bio:
        return l10n.bio;
      case WasteType.ash:
        return l10n.ash;
      case WasteType.bulky:
        return l10n.bulky;
      case WasteType.green:
        return l10n.green;
      case WasteType.elektro:
        return l10n.elektro;
      case WasteType.opony:
        return l10n.opony;
    }
  }

  /// Maps original API waste type string (PL only) to localization key
  static String getWasteTypeKeyFromApiString(String apiWasteType) {
    switch (apiWasteType) {
      case 'Zmieszane':
        return 'mixed';
      case 'Papier':
        return 'paper';
      case 'Szkło':
        return 'glass';
      case 'Metale i tworzywa sztuczne':
        return 'plastic';
      case 'Bio':
        return 'bio';
      case 'Popiół':
        return 'ash';
      case 'Gabaryty':
        return 'bulky';
      case 'Odpady zielone':
      case 'Choinki':
        return 'green';
      case 'Elektro':
        return 'elektro';
      case 'Opony':
        return 'opony';
      case 'Inne':
        return 'mixed';
      default:
        return 'mixed';
    }
  }

  /// Gets localized waste type name from API string
  static String getLocalizedWasteTypeNameFromApiString(AppLocalizations l10n, String apiWasteType) {
    final key = getWasteTypeKeyFromApiString(apiWasteType);
    return getLocalizedWasteTypeName(l10n, _keyToWasteType(key));
  }

  /// Maps localization key to WasteType enum
  static WasteType _keyToWasteType(String key) {
    switch (key) {
      case 'mixed':
        return WasteType.mixed;
      case 'paper':
        return WasteType.paper;
      case 'glass':
        return WasteType.glass;
      case 'plastic':
        return WasteType.metal;
      case 'bio':
        return WasteType.bio;
      case 'ash':
        return WasteType.ash;
      case 'bulky':
        return WasteType.bulky;
      case 'green':
        return WasteType.green;
      case 'elektro':
        return WasteType.elektro;
      case 'opony':
        return WasteType.opony;
      default:
        return WasteType.mixed;
    }
  }
}
