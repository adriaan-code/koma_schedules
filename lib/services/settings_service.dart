import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  factory SettingsService() => _instance;
  SettingsService._internal();
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _locationAccessKey = 'location_access';
  static const String _selectedLanguageKey = 'selected_language';
  static const String _notificationHourKey = 'notification_hour';
  static const String _notificationMinuteKey = 'notification_minute';

  // Domyślne wartości
  static const bool _defaultNotificationsEnabled = true;
  static const bool _defaultLocationAccess = false;
  static const String _defaultSelectedLanguage = 'Polski';
  static const int _defaultNotificationHour = 7;
  static const int _defaultNotificationMinute = 0;

  // Singleton pattern
  static final SettingsService _instance = SettingsService._internal();

  // Cache dla ustawień
  bool? _notificationsEnabled;
  bool? _locationAccess;
  String? _selectedLanguage;
  int? _notificationHour;
  int? _notificationMinute;

  // Getters z cache
  Future<bool> get notificationsEnabled async {
    if (_notificationsEnabled == null) {
      final prefs = await SharedPreferences.getInstance();
      _notificationsEnabled =
          prefs.getBool(_notificationsEnabledKey) ??
          _defaultNotificationsEnabled;
    }
    return _notificationsEnabled!;
  }

  Future<bool> get locationAccess async {
    if (_locationAccess == null) {
      final prefs = await SharedPreferences.getInstance();
      _locationAccess =
          prefs.getBool(_locationAccessKey) ?? _defaultLocationAccess;
    }
    return _locationAccess!;
  }

  Future<String> get selectedLanguage async {
    if (_selectedLanguage == null) {
      final prefs = await SharedPreferences.getInstance();
      _selectedLanguage =
          prefs.getString(_selectedLanguageKey) ?? _defaultSelectedLanguage;
    }
    return _selectedLanguage!;
  }

  Future<int> get notificationHour async {
    if (_notificationHour == null) {
      final prefs = await SharedPreferences.getInstance();
      _notificationHour =
          prefs.getInt(_notificationHourKey) ?? _defaultNotificationHour;
    }
    return _notificationHour!;
  }

  Future<int> get notificationMinute async {
    if (_notificationMinute == null) {
      final prefs = await SharedPreferences.getInstance();
      _notificationMinute =
          prefs.getInt(_notificationMinuteKey) ?? _defaultNotificationMinute;
    }
    return _notificationMinute!;
  }

  // Setters
  Future<void> setNotificationsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, value);
    _notificationsEnabled = value;
  }

  Future<void> setLocationAccess(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_locationAccessKey, value);
    _locationAccess = value;
  }

  Future<void> setSelectedLanguage(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedLanguageKey, value);
    _selectedLanguage = value;
  }

  Future<void> setNotificationTime(int hour, int minute) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_notificationHourKey, hour);
    await prefs.setInt(_notificationMinuteKey, minute);
    _notificationHour = hour;
    _notificationMinute = minute;
  }

  // Metoda do czyszczenia cache (np. po wylogowaniu)
  void clearCache() {
    _notificationsEnabled = null;
    _locationAccess = null;
    _selectedLanguage = null;
    _notificationHour = null;
    _notificationMinute = null;
  }

  // Metoda do resetowania wszystkich ustawień do domyślnych
  Future<void> resetToDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_notificationsEnabledKey);
    await prefs.remove(_locationAccessKey);
    await prefs.remove(_selectedLanguageKey);
    await prefs.remove(_notificationHourKey);
    await prefs.remove(_notificationMinuteKey);
    clearCache();
  }

  /// Pobiera kod języka (pl, en, uk)
  Future<String> getLanguageCode() async {
    final language = await selectedLanguage;
    switch (language) {
      case 'English':
        return 'en';
      case 'Українська':
        return 'uk';
      case 'Polski':
      default:
        return 'pl';
    }
  }

  /// Ustawia język na podstawie kodu
  Future<void> setLanguageByCode(String languageCode) async {
    String languageName;
    switch (languageCode) {
      case 'en':
        languageName = 'English';
        break;
      case 'uk':
        languageName = 'Українська';
        break;
      case 'pl':
      default:
        languageName = 'Polski';
        break;
    }
    await setSelectedLanguage(languageName);
  }
}
