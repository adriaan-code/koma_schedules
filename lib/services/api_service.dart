import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import '../models/address.dart';
import '../models/api_models.dart';
import '../models/waste_collection.dart';
import '../models/waste_type.dart';

class ApiService {
  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Interceptor dla retry logic
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          if (_shouldRetry(error)) {
            try {
              // Retry request
              final response = await _dio.fetch<dynamic>(error.requestOptions);
              return handler.resolve(response);
            } catch (e) {
              return handler.next(error);
            }
          }
          return handler.next(error);
        },
      ),
    );

    // Interceptor dla logowania requestów (tylko w debug mode)
    if (const bool.fromEnvironment('dart.vm.product') == false) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: false, // Wyłącz w produkcji dla wydajności
          responseBody: false,
          error: true,
        ),
      );
    }
  }
  static const String _baseUrl = ApiConfig.baseUrl;
  late final Dio _dio;

  // Cache dla sektorów (rzadko się zmieniają)
  static ApiSectorsResponse? _cachedSectors;
  static DateTime? _sectorsCacheTime;
  static const Duration _sectorsCacheExpiry = Duration(hours: 24);

  // Cache dla harmonogramów (ważne przez kilka godzin)
  static final Map<String, List<WasteCollection>> _scheduleCache = {};
  static final Map<String, DateTime> _scheduleCacheTime = {};
  static const Duration _scheduleCacheExpiry = Duration(hours: 6);

  /// Sprawdza czy request powinien zostać ponowiony
  bool _shouldRetry(DioException error) {
    // Retry tylko dla błędów sieciowych i 500+ statusów
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.unknown ||
        (error.response?.statusCode != null &&
            error.response!.statusCode! >= 500);
  }

  /// Waliduje input dla API calls
  void _validateInput(String value, String fieldName) {
    if (value.trim().isEmpty) {
      throw Exception('$fieldName nie może być pusty');
    }
    if (value.length > 100) {
      throw Exception('$fieldName jest zbyt długi (max 100 znaków)');
    }
  }

  /// Pobiera harmonogram odbiorów dla danej posesji z cache'owaniem
  Future<List<WasteCollection>> getWasteSchedule(
    String prefix,
    String numerPosesji,
  ) async {
    // Walidacja inputu
    _validateInput(prefix, 'Prefix');
    _validateInput(numerPosesji, 'Numer posesji');

    final cacheKey = '$prefix/$numerPosesji';

    // Sprawdź cache
    if (_scheduleCache.containsKey(cacheKey) &&
        _scheduleCacheTime.containsKey(cacheKey)) {
      final cacheTime = _scheduleCacheTime[cacheKey]!;
      if (DateTime.now().difference(cacheTime) < _scheduleCacheExpiry) {
        return _scheduleCache[cacheKey]!;
      }
    }

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiConfig.wasteScheduleEndpoint,
        queryParameters: {'value': cacheKey},
      );

      if (response.statusCode == 200) {
        final apiResponse = ApiScheduleResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
        final collections = _convertApiCollectionsToWasteCollections(
          apiResponse.odbior,
        );

        // Zapisz w cache
        _scheduleCache[cacheKey] = collections;
        _scheduleCacheTime[cacheKey] = DateTime.now();

        return collections;
      } else {
        throw Exception('Błąd pobierania harmonogramu: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Jeśli jest błąd połączenia i mamy cache, zwróć cache
      if (_scheduleCache.containsKey(cacheKey) &&
          (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout ||
              e.type == DioExceptionType.sendTimeout ||
              e.type == DioExceptionType.unknown)) {
        return _scheduleCache[cacheKey]!;
      }
      throw _handleDioError(e);
    } catch (e) {
      // Jeśli jest jakikolwiek błąd i mamy cache, zwróć cache
      if (_scheduleCache.containsKey(cacheKey)) {
        return _scheduleCache[cacheKey]!;
      }
      throw Exception('Nieoczekiwany błąd: $e');
    }
  }

  /// Pobiera wszystkie sektory i miejscowości z API KOMA z cache'owaniem
  Future<ApiSectorsResponse> getSectors() async {
    // Sprawdź cache
    if (_cachedSectors != null && _sectorsCacheTime != null) {
      if (DateTime.now().difference(_sectorsCacheTime!) < _sectorsCacheExpiry) {
        return _cachedSectors!;
      }
    }

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiConfig.sectorsEndpoint,
      );

      if (response.statusCode == 200) {
        final sectorsResponse = ApiSectorsResponse.fromJson(
          response.data as Map<String, dynamic>,
        );

        // Zapisz w cache
        _cachedSectors = sectorsResponse;
        _sectorsCacheTime = DateTime.now();

        return sectorsResponse;
      } else {
        throw Exception('Błąd pobierania sektorów: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Jeśli jest błąd połączenia i mamy cache, zwróć cache
      if (_cachedSectors != null &&
          (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout ||
              e.type == DioExceptionType.sendTimeout ||
              e.type == DioExceptionType.unknown)) {
        return _cachedSectors!;
      }
      throw _handleDioError(e);
    } catch (e) {
      // Jeśli jest jakikolwiek błąd i mamy cache, zwróć cache
      if (_cachedSectors != null) {
        return _cachedSectors!;
      }
      throw Exception('Nieoczekiwany błąd: $e');
    }
  }

  /// Wyszukuje miejscowości na podstawie zapytania
  Future<List<Address>> searchAddresses(String query) async {
    try {
      final sectorsResponse = await getSectors();
      final matchingLocations = sectorsResponse.searchLocations(query);

      return matchingLocations
          .map((location) => _convertApiLocationToAddress(location))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Nieoczekiwany błąd: $e');
    }
  }

  /// Pobiera wszystkie dostępne miejscowości
  Future<List<Address>> getAllLocations() async {
    try {
      final sectorsResponse = await getSectors();
      final allLocations = sectorsResponse.getAllLocations();

      return allLocations
          .map((location) => _convertApiLocationToAddress(location))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Nieoczekiwany błąd: $e');
    }
  }

  /// Pobiera ulice na podstawie prefiksu, gminy i miejscowości
  Future<List<ApiStreet>> getStreets(
    String prefiks,
    String gmina,
    String miejscowosc,
  ) async {
    // Walidacja inputu
    _validateInput(prefiks, 'Prefiks');
    _validateInput(gmina, 'Gmina');
    _validateInput(miejscowosc, 'Miejscowość');

    try {
      final response = await _dio.get<List<dynamic>>(
        '${ApiConfig.streetsEndpoint}/$prefiks/$gmina/$miejscowosc',
      );

      if (response.statusCode == 200) {
        return ApiStreetsResponse.fromJson(
          response.data as List<dynamic>,
        ).streets;
      } else {
        throw Exception('Błąd pobierania ulic: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Nieoczekiwany błąd: $e');
    }
  }

  /// Pobiera posesje na podstawie prefiksu, gminy, miejscowości i ulicy
  Future<List<ApiProperty>> getProperties(
    String prefiks,
    String gmina,
    String miejscowosc,
    String ulica,
  ) async {
    // Walidacja inputu
    _validateInput(prefiks, 'Prefiks');
    _validateInput(gmina, 'Gmina');
    _validateInput(miejscowosc, 'Miejscowość');
    // ulica może być pusta dla niektórych miejscowości

    try {
      final response = await _dio.get<List<dynamic>>(
        '${ApiConfig.propertiesEndpoint}/$prefiks/$gmina/$miejscowosc/$ulica',
      );

      if (response.statusCode == 200) {
        // API zwraca bezpośrednio tablicę posesji
        final List<ApiProperty> properties = [];
        if (response.data is List) {
          final dataList = response.data as List<dynamic>;
          for (final propertyData in dataList) {
            if (propertyData is Map<String, dynamic>) {
              properties.add(ApiProperty.fromJson(propertyData));
            }
          }
        }
        return properties;
      } else {
        throw Exception('Błąd pobierania posesji: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Nieoczekiwany błąd: $e');
    }
  }

  /// Pobiera szczegóły odbioru dla danego typu odpadu
  Future<Map<String, dynamic>> getWasteTypeDetails(String wasteType) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/waste-types/$wasteType',
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Błąd pobierania szczegółów: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Nieoczekiwany błąd: $e');
    }
  }

  /// Wyszukuje odpady na podstawie nazwy
  Future<List<ApiWasteSearchResult>> searchWaste(String query) async {
    // Walidacja inputu - minimum 3 znaki
    if (query.trim().length < 3) {
      throw Exception('Wpisz co najmniej 3 znaki, aby wyszukać odpady');
    }

    try {
      if (kDebugMode) {
        debugPrint('Searching for waste: $query');
        debugPrint(
          'URL: ${ApiConfig.wpJsonBaseUrl}${ApiConfig.wasteSearchEndpoint}?nazwa=${query.trim()}',
        );
      }

      final response = await _dio.get<Map<String, dynamic>>(
        '${ApiConfig.wpJsonBaseUrl}${ApiConfig.wasteSearchEndpoint}',
        queryParameters: {'nazwa': query.trim()},
      );

      if (kDebugMode) {
        debugPrint('Response status: ${response.statusCode}');
        debugPrint('Response data type: ${response.data.runtimeType}');
        debugPrint(
          'Response data length: ${response.data is List ? (response.data as List).length : 'not a list'}',
        );
      }

      if (response.statusCode == 200) {
        final List<ApiWasteSearchResult> results = [];

        // API zwraca obiekt z 'count' i 'data' array
        if (response.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;
          final count = responseData['count'] as int?;
          final dataList = responseData['data'] as List<dynamic>?;

          if (kDebugMode) {
            debugPrint('API returned $count results total');
          }

          if (dataList != null) {
            // Limit do 5 wyników
            final limitedList = dataList.take(5).toList();

            for (final wasteData in limitedList) {
              if (wasteData is Map<String, dynamic>) {
                try {
                  results.add(ApiWasteSearchResult.fromJson(wasteData));
                } catch (e) {
                  if (kDebugMode) {
                    debugPrint('Error parsing waste item: $e');
                  }
                }
              }
            }
          }
        } else if (response.data is List) {
          // Fallback dla przypadku gdy API zwraca bezpośrednio array
          final dataList = response.data as List<dynamic>;
          final limitedList = dataList.take(5).toList();

          for (final wasteData in limitedList) {
            if (wasteData is Map<String, dynamic>) {
              try {
                results.add(ApiWasteSearchResult.fromJson(wasteData));
              } catch (e) {
                if (kDebugMode) {
                  debugPrint('Error parsing waste item: $e');
                }
              }
            }
          }
        }

        if (kDebugMode) {
          debugPrint('Parsed ${results.length} results (showing max 5)');
        }

        // Zwróć puste wyniki zamiast rzucać wyjątek - UI obsłuży to lepiej
        return results;
      } else {
        throw Exception('Błąd wyszukiwania odpadów: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint('DioException in searchWaste: ${e.type}');
        debugPrint('Message: ${e.message}');
        debugPrint('Response: ${e.response?.data}');
      }
      throw _handleDioError(e);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('General exception in searchWaste: $e');
      }
      throw Exception('Nieoczekiwany błąd: $e');
    }
  }

  /// Konwertuje dane z API na modele aplikacji
  List<WasteCollection> _convertApiCollectionsToWasteCollections(
    List<ApiWasteCollection> apiCollections,
  ) {
    return apiCollections.map((apiCollection) {
      return WasteCollection(
        day: apiCollection.data.day,
        month: _getMonthName(apiCollection.data.month),
        wasteType: _stringToWasteType(apiCollection.typ),
        startTime: ApiConfig.defaultStartTime,
        endTime: ApiConfig.defaultEndTime,
        dayOfWeek: _getDayOfWeekName(apiCollection.data.weekday),
        originalTypeName: apiCollection.typ, // Oryginalna nazwa z API
      );
    }).toList();
  }

  /// Konwertuje ApiLocation na model Address
  Address _convertApiLocationToAddress(ApiLocation apiLocation) {
    return Address(
      street: apiLocation.miejscowosc,
      city: apiLocation.gmina,
      postalCode: '', // API KOMA nie zwraca kodu pocztowego
    );
  }

  /// Mapuje string na enum WasteType
  WasteType _stringToWasteType(String wasteTypeString) {
    final type = wasteTypeString.toLowerCase();
    
    // Green waste variants
    if (['odpady zielone', 'zielone', 'rosliny', 'rośliny', 'choinki', 'green', 'green waste'].contains(type)) {
      return WasteType.green;
    }
    
    // Bulky waste variants
    if (['gabaryty', 'bulky'].contains(type)) {
      return WasteType.bulky;
    }
    
    // Elektro waste
    if (['elektro'].contains(type)) {
      return WasteType.elektro;
    }
    
    // Opony waste
    if (['opony'].contains(type)) {
      return WasteType.opony;
    }
    
    // Mixed waste variants
    if (['zmieszane', 'mixed', 'inne'].contains(type)) {
      return WasteType.mixed;
    }
    
    // Direct mappings
    switch (type) {
      case 'papier':
      case 'paper':
        return WasteType.paper;
      case 'szkło':
      case 'glass':
        return WasteType.glass;
      case 'metale i tworzywa sztuczne':
      case 'metal':
        return WasteType.metal;
      case 'popiół':
      case 'ash':
        return WasteType.ash;
      case 'bio':
      case 'biodegradowalne':
        return WasteType.bio;
      default:
        return WasteType.mixed;
    }
  }

  /// Pobiera klucz nazwy miesiąca (do użycia z l10n)
  String _getMonthName(int month) {
    // Zwracamy klucze lokalizacji zamiast zakodowanych nazw
    const months = [
      'january',
      'february',
      'march',
      'april',
      'may',
      'june',
      'july',
      'august',
      'september',
      'october',
      'november',
      'december',
    ];
    return months[month - 1];
  }

  /// Pobiera klucz nazwy dnia tygodnia (do użycia z l10n)
  String _getDayOfWeekName(int weekday) {
    // Zwracamy klucze lokalizacji zamiast zakodowanych nazw
    const days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    return days[weekday - 1];
  }

  /// Obsługuje błędy Dio
  Exception _handleDioError(DioException error) {
    // Logowanie błędów w trybie debug
    if (kDebugMode) {
      debugPrint('DioError: ${error.type}');
      debugPrint('Message: ${error.message}');
      debugPrint('Response: ${error.response?.data}');
      debugPrint('Status Code: ${error.response?.statusCode}');
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception(
          'Przekroczono czas oczekiwania. Sprawdź połączenie internetowe.',
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 404) {
          return Exception('Nie znaleziono harmonogramu dla tego adresu.');
        } else if (statusCode == 500) {
          return Exception('Błąd serwera. Spróbuj ponownie później.');
        } else {
          return Exception('Błąd serwera: $statusCode');
        }
      case DioExceptionType.cancel:
        return Exception('Żądanie zostało anulowane.');
      case DioExceptionType.unknown:
      default:
        return Exception(
          'Brak połączenia z internetem. Sprawdź połączenie i spróbuj ponownie.',
        );
    }
  }

  /// Czyści cache harmonogramów
  static void clearScheduleCache() {
    _scheduleCache.clear();
    _scheduleCacheTime.clear();
  }

  /// Czyści cache sektorów
  static void clearSectorsCache() {
    _cachedSectors = null;
    _sectorsCacheTime = null;
  }

  /// Czyści cały cache
  static void clearAllCache() {
    clearScheduleCache();
    clearSectorsCache();
  }
}
