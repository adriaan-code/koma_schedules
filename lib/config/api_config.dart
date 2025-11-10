/// Centralna konfiguracja API dla aplikacji KOMA
class ApiConfig {
  // Prywatny konstruktor - klasa tylko ze statycznymi polami
  ApiConfig._();

  // ==================== URLs ====================

  /// Główny URL API KOMA (BOK)
  static const String baseUrl = 'https://bok.koma.pl/api';

  /// URL dla WP JSON API (baza wiedzy o odpadach)
  static const String wpJsonBaseUrl = 'https://koma.pl/wp-json/custom/v1';

  // ==================== Endpointy API KOMA ====================

  /// Endpoint dla sektorów
  static const String sectorsEndpoint = '/sektory';

  /// Endpoint dla ulic: /ulice/{prefix}/{gmina}/{miejscowosc}
  static const String streetsEndpoint = '/ulice';

  /// Endpoint dla posesji: /posesje/{prefix}/{gmina}/{miejscowosc}/{ulica}
  static const String propertiesEndpoint = '/posesje';

  /// Endpoint harmonogramu: /apiharmonogram?value={prefix}/{nr_posesji}
  static const String wasteScheduleEndpoint = '/apiharmonogram';

  /// Endpoint wyszukiwania odpadów (WP JSON): /odpady?nazwa={query}
  static const String wasteSearchEndpoint = '/odpady';

  // ==================== Timeouty ====================

  /// Timeout połączenia
  static const Duration connectTimeout = Duration(seconds: 10);

  /// Timeout odbierania danych
  static const Duration receiveTimeout = Duration(seconds: 10);

  /// Timeout wysyłania danych
  static const Duration sendTimeout = Duration(seconds: 10);

  // ==================== Cache ====================

  /// Czas cache'owania sektorów (rzadko się zmieniają)
  static const Duration sectorsCacheExpiry = Duration(hours: 24);

  /// Czas cache'owania harmonogramów
  static const Duration scheduleCacheExpiry = Duration(hours: 6);

  // ==================== Headers ====================

  /// Domyślne nagłówki HTTP
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // ==================== Limity ====================

  /// Maksymalna liczba wyników wyszukiwania odpadów
  static const int maxWasteSearchResults = 5;

  /// Maksymalna długość zapytania
  static const int maxQueryLength = 100;

  /// Minimalna długość zapytania do wyszukiwania
  static const int minQueryLength = 3;

  // ==================== Godziny odbioru ====================

  /// Domyślna godzina rozpoczęcia odbioru
  static const String defaultStartTime = '06:00';

  /// Domyślna godzina zakończenia odbioru
  static const String defaultEndTime = '20:00';
}
