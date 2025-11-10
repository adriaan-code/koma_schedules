# Settings Service

Serwis do zarządzania ustawieniami aplikacji z automatycznym zapisywaniem i ładowaniem z `SharedPreferences`.

## Funkcjonalności

- ✅ **Automatyczne zapisywanie** - wszystkie zmiany są automatycznie zapisywane
- ✅ **Cache** - ustawienia są cachowane w pamięci dla szybkiego dostępu
- ✅ **Domyślne wartości** - bezpieczne domyślne wartości dla wszystkich ustawień
- ✅ **Singleton pattern** - jeden globalny serwis dla całej aplikacji
- ✅ **Type safety** - pełne wsparcie dla typów Dart

## Dostępne ustawienia

### 1. Powiadomienia
```dart
// Sprawdzenie czy powiadomienia są włączone
bool enabled = await SettingsService().notificationsEnabled;

// Włączenie/wyłączenie powiadomień
await SettingsService().setNotificationsEnabled(true);
```

### 2. Dostęp do lokalizacji
```dart
// Sprawdzenie dostępu do lokalizacji
bool access = await SettingsService().locationAccess;

// Ustawienie dostępu do lokalizacji
await SettingsService().setLocationAccess(true);
```

### 3. Język aplikacji
```dart
// Pobranie wybranego języka
String language = await SettingsService().selectedLanguage;

// Ustawienie języka
await SettingsService().setSelectedLanguage('English');
```

### 4. Godzina powiadomień
```dart
// Pobranie godziny powiadomień
int hour = await SettingsService().notificationHour;
int minute = await SettingsService().notificationMinute;

// Ustawienie godziny powiadomień
await SettingsService().setNotificationTime(8, 30); // 8:30
```

## Przykład użycia

```dart
import '../services/settings_service.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final SettingsService _settingsService = SettingsService();
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final enabled = await _settingsService.notificationsEnabled;
    setState(() {
      _notificationsEnabled = enabled;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    setState(() {
      _notificationsEnabled = value;
    });
    await _settingsService.setNotificationsEnabled(value);
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _notificationsEnabled,
      onChanged: _toggleNotifications,
    );
  }
}
```

## Metody pomocnicze

### Czyszczenie cache
```dart
// Wyczyść cache (np. po wylogowaniu)
SettingsService().clearCache();
```

### Reset do domyślnych wartości
```dart
// Zresetuj wszystkie ustawienia do domyślnych
await SettingsService().resetToDefaults();
```

## Domyślne wartości

- **Powiadomienia**: `true` (włączone)
- **Dostęp do lokalizacji**: `false` (wyłączony)
- **Język**: `'Polski'`
- **Godzina powiadomień**: `7:00`

## Klucze SharedPreferences

- `notifications_enabled` - bool
- `location_access` - bool
- `selected_language` - String
- `notification_hour` - int
- `notification_minute` - int

## Thread Safety

Serwis jest thread-safe i może być używany z wielu miejsc jednocześnie. Wszystkie operacje są asynchroniczne.
