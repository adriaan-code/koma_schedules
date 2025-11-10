import '../l10n/app_localizations.dart';

/// Konwertuje klucz miesiąca na przetłumaczoną nazwę
String getLocalizedMonthName(AppLocalizations l10n, String monthKey) {
  final monthName = _getMonthName(l10n, monthKey.toLowerCase());
  return monthName.toUpperCase();
}

/// Pobiera nazwę miesiąca z lokalizacji
String _getMonthName(AppLocalizations l10n, String monthKey) {
  switch (monthKey) {
    case 'january':
      return l10n.january;
    case 'february':
      return l10n.february;
    case 'march':
      return l10n.march;
    case 'april':
      return l10n.april;
    case 'may':
      return l10n.may;
    case 'june':
      return l10n.june;
    case 'july':
      return l10n.july;
    case 'august':
      return l10n.august;
    case 'september':
      return l10n.september;
    case 'october':
      return l10n.october;
    case 'november':
      return l10n.november;
    case 'december':
      return l10n.december;
    default:
      return monthKey;
  }
}

/// Konwertuje klucz dnia tygodnia na przetłumaczoną nazwę
String getLocalizedDayName(AppLocalizations l10n, String dayKey) {
  final dayName = _getDayName(l10n, dayKey.toLowerCase());
  return dayName.toUpperCase();
}

/// Pobiera nazwę dnia z lokalizacji
String _getDayName(AppLocalizations l10n, String dayKey) {
  switch (dayKey) {
    case 'monday':
      return l10n.monday;
    case 'tuesday':
      return l10n.tuesday;
    case 'wednesday':
      return l10n.wednesday;
    case 'thursday':
      return l10n.thursday;
    case 'friday':
      return l10n.friday;
    case 'saturday':
      return l10n.saturday;
    case 'sunday':
      return l10n.sunday;
    default:
      return dayKey;
  }
}

