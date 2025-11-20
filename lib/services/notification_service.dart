import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import '../models/address.dart';
import 'api_service.dart';
import 'settings_service.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static final SettingsService _settingsService = SettingsService();
  static final ApiService _apiService = ApiService();

  static bool _isInitialized = false;

  /// Inicjalizuje serwis powiadomień
  static Future<void> initialize() async {
    if (_isInitialized) {
      if (kDebugMode) {
        debugPrint('Serwis powiadomień już zainicjalizowany');
      }
      return;
    }

    if (kDebugMode) {
      debugPrint('=== INICJALIZACJA SERWISU POWIADOMIEŃ ===');
      debugPrint('Platforma: ${Platform.isIOS ? "iOS" : "Android"}');
    }

    try {
      // Inicjalizuj timezone
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Europe/Warsaw'));
      
      if (kDebugMode) {
        debugPrint('Timezone zainicjalizowany: Europe/Warsaw');
      }

      // Konfiguracja dla Android
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      // Konfiguracja dla iOS
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        defaultPresentAlert: true,
        defaultPresentSound: true,
        defaultPresentBadge: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      if (kDebugMode) {
        debugPrint('Inicjalizuję flutter_local_notifications...');
      }

      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      if (kDebugMode) {
        debugPrint('flutter_local_notifications zainicjalizowany');
      }

      // Na iOS, poproś o uprawnienia od razu
      if (await _isIOS()) {
        if (kDebugMode) {
          debugPrint('Proszę o uprawnienia iOS...');
        }
        await _requestIOSPermissions();
      }

      _isInitialized = true;
      
      if (kDebugMode) {
        debugPrint('Serwis powiadomień zainicjalizowany pomyślnie');
        debugPrint('=============================================');
      }

      // Upewnij się, że harmonogram i zdalne subskrypcje są zsynchronizowane przy starcie aplikacji.
      await updateNotifications();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Błąd inicjalizacji serwisu powiadomień: $e');
        debugPrint('Stack trace: ${StackTrace.current}');
      }
      rethrow;
    }
  }
  
  /// Sprawdza czy to iOS
  static Future<bool> _isIOS() async {
    return Platform.isIOS;
  }
  
  /// Prosi o uprawnienia na iOS
  static Future<void> _requestIOSPermissions() async {
    final iosPlugin = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    
    if (iosPlugin != null) {
      if (kDebugMode) {
        debugPrint('Sprawdzam aktualne uprawnienia iOS...');
      }
      
      // Sprawdź aktualne uprawnienia
      final currentPermissions = await iosPlugin.checkPermissions();
      if (kDebugMode) {
        debugPrint('Aktualne uprawnienia:');
        debugPrint('  Enabled: ${currentPermissions?.isEnabled}');
        debugPrint('  Alert: ${currentPermissions?.isAlertEnabled}');
        debugPrint('  Badge: ${currentPermissions?.isBadgeEnabled}');
        debugPrint('  Sound: ${currentPermissions?.isSoundEnabled}');
      }
      
      // Proś o uprawnienia
      if (kDebugMode) {
        debugPrint('Proszę o uprawnienia iOS...');
      }
      
      await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      
      if (kDebugMode) {
        debugPrint('Prośba o uprawnienia iOS wysłana');
        
        // Sprawdź uprawnienia po prośbie
        final newPermissions = await iosPlugin.checkPermissions();
        debugPrint('Uprawnienia iOS po prośbie:');
        debugPrint('  Enabled: ${newPermissions?.isEnabled}');
        debugPrint('  Alert: ${newPermissions?.isAlertEnabled}');
        debugPrint('  Badge: ${newPermissions?.isBadgeEnabled}');
        debugPrint('  Sound: ${newPermissions?.isSoundEnabled}');
      }
    } else {
      if (kDebugMode) {
        debugPrint('BŁĄD: Nie można uzyskać iOS plugin dla powiadomień');
      }
    }
  }

  /// Obsługa kliknięcia w powiadomienie
  static void _onNotificationTapped(NotificationResponse response) {
    // Można dodać nawigację do konkretnego ekranu
    if (kDebugMode) {
      debugPrint('Powiadomienie kliknięte: ${response.payload}');
    }
  }

  /// Sprawdza i prosi o uprawnienia do powiadomień
  static Future<bool> requestNotificationPermission() async {
    // Dla Android 13+ (API 33+)
    if (await Permission.notification.isDenied) {
      final status = await Permission.notification.request();
      if (!status.isGranted) return false;
    }

    // Dla Android 12+ (API 31+) - uprawnienia do dokładnych alarmów
    if (await Permission.scheduleExactAlarm.isDenied) {
      final status = await Permission.scheduleExactAlarm.request();
      if (!status.isGranted) return false;
    }

    // Dla starszych wersji Android
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      return granted ?? false;
    }

    return true;
  }

  /// Sprawdza czy powiadomienia są włączone
  static Future<bool> areNotificationsEnabled() async {
    return await _settingsService.notificationsEnabled;
  }

  /// Sprawdza czy ma uprawnienia do dokładnych alarmów
  static Future<bool> canScheduleExactAlarms() async {
    return await Permission.scheduleExactAlarm.isGranted;
  }

  /// Ustawia powiadomienia o odpadach dla wszystkich włączonych lokalizacji
  static Future<void> scheduleDailyWasteNotification() async {
    if (kDebugMode) {
      debugPrint('=== PLANOWANIE POWIADOMIEŃ DLA LOKALIZACJI ===');
    }
    
    if (!await areNotificationsEnabled()) {
      if (kDebugMode) {
        debugPrint('Powiadomienia wyłączone - anuluję wszystkie');
      }
      await cancelAllNotifications();
      return;
    }

    final hour = await _settingsService.notificationHour;
    final minute = await _settingsService.notificationMinute;
    
    if (kDebugMode) {
      debugPrint('Godzina powiadomienia: $hour:$minute');
    }

    // Anuluj poprzednie powiadomienia
    await cancelAllNotifications();

    // Pobierz wszystkie włączone lokalizacje
    final enabledLocations = await _settingsService.getEnabledLocations();
    
    if (enabledLocations.isEmpty) {
      if (kDebugMode) {
        debugPrint('Brak włączonych lokalizacji - brak powiadomień do zaplanowania');
      }
      return;
    }

    if (kDebugMode) {
      debugPrint('Znaleziono ${enabledLocations.length} włączonych lokalizacji');
    }

    // Wybierz tryb planowania na podstawie uprawnień
    final canScheduleExact = await canScheduleExactAlarms();
    final scheduleMode = canScheduleExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;
    
    if (kDebugMode) {
      debugPrint('Tryb planowania: ${canScheduleExact ? "dokładny" : "przybliżony"}');
    }

    // Używamy unikalnych ID opartych na hash lokalizacji i daty, aby uniknąć konfliktów
    // Zaczynamy od 1000, aby uniknąć problemów z niskimi ID na iOS
    int baseNotificationId = 1000;
    final now = tz.TZDateTime.now(tz.local);
    int scheduledCount = 0;

    // Map do śledzenia, ile powiadomień jest zaplanowanych na każdy dzień
    // Używamy tego, aby dodać małe opóźnienie między powiadomieniami dla różnych lokalizacji
    final Map<String, int> notificationsPerDay = {};

    // Dla każdej lokalizacji planuj powiadomienia
    for (final location in enabledLocations) {
      if (location.address.prefix == null || location.address.propertyNumber == null) {
        if (kDebugMode) {
          debugPrint('Pomijam lokalizację "${location.name}" - brak pełnych danych adresu');
        }
        continue;
      }

      try {
        // Pobierz harmonogram dla tej lokalizacji
        final schedule = await _apiService.getWasteSchedule(
          location.address.prefix!,
          location.address.propertyNumber!,
        );

        if (kDebugMode) {
          debugPrint('Lokalizacja "${location.name}": znaleziono ${schedule.length} zbiórek');
          if (schedule.isEmpty) {
            debugPrint('  ⚠️ Harmonogram jest pusty dla tej lokalizacji!');
          } else {
            debugPrint('  Przykładowe zbiórki:');
            for (int i = 0; i < schedule.length && i < 5; i++) {
              debugPrint('    - ${schedule[i].month} ${schedule[i].day}: ${schedule[i].originalTypeName}');
            }
          }
        }

        int locationScheduledCount = 0;

        // Planuj powiadomienia na najbliższe 60 dni
        // WAŻNE: Planujemy najpierw przyszłe dni (1-60), a na końcu dzisiaj (0)
        // To zapewnia, że powiadomienia na dzisiaj nie zostaną odrzucone przez iOS
        // gdy przekraczamy limit liczby powiadomień
        for (int dayOffset = 1; dayOffset < 60; dayOffset++) {
          final targetDate = now.add(Duration(days: dayOffset));
          final targetDay = targetDate.day;

          // Znajdź zbiórki na ten dzień
          // month w WasteCollection to klucz lokalizacji ('january', 'february' itd.)
          final targetMonthKey = _getMonthKey(targetDate.month);
          final collectionsForDay = schedule.where((collection) {
            return collection.day == targetDay && 
                   collection.month.toLowerCase() == targetMonthKey.toLowerCase();
          }).toList();

          if (kDebugMode && dayOffset == 0) {
            debugPrint('  🔍 DZISIAJ (${targetDate.day}.${targetDate.month}.${targetDate.year}):');
            debugPrint('    Szukam: dzień=$targetDay, miesiąc=$targetMonthKey');
            debugPrint('    Znaleziono zbiórek: ${collectionsForDay.length}');
            if (collectionsForDay.isEmpty) {
              debugPrint('    ⚠️ BRAK ZBIÓREK DZISIAJ dla lokalizacji "${location.name}"');
              // Pokaż przykładowe zbiórki z harmonogramu
              if (schedule.isNotEmpty) {
                debugPrint('    Przykładowe zbiórki z harmonogramu:');
                for (int i = 0; i < schedule.length && i < 3; i++) {
                  debugPrint('      - ${schedule[i].month} ${schedule[i].day}: ${schedule[i].originalTypeName}');
                }
              }
            }
          }

          if (collectionsForDay.isEmpty) continue;

          if (kDebugMode && dayOffset < 7) {
            debugPrint('  📅 ${targetDate.day}.${targetDate.month}.${targetDate.year}: znaleziono ${collectionsForDay.length} zbiórek');
          }

          // Utwórz tekst powiadomienia z nowym formatem
          final wasteTypes = collectionsForDay
              .map((c) => c.originalTypeName)
              .toSet()
              .toList();
          
          String frakcjaText;
          if (wasteTypes.length == 1) {
            frakcjaText = wasteTypes.first;
          } else {
            frakcjaText = wasteTypes.join(', ');
          }

          // Wyróżnij frakcję używając emoji i znaków specjalnych
          // (flutter_local_notifications nie obsługuje HTML/pogrubienia)
          final notificationBody = 
              '🗑️✨ Ekipa już w gotowości! Dziś zabieramy ⚡ $frakcjaText ⚡. Nie zapomnij wystawić pojemnika – nie lubi czekać! 😄';

          // Klucz dla dnia (używamy do śledzenia liczby powiadomień)
          final dayKey = '${targetDate.year}-${targetDate.month}-${targetDate.day}';
          final delayMinutes = notificationsPerDay[dayKey] ?? 0;
          notificationsPerDay[dayKey] = delayMinutes + 1;

          // Zaplanuj powiadomienie na wybraną godzinę w dniu zbiórki
          // Dodajemy małe opóźnienie (1 minuta) dla każdej kolejnej lokalizacji w tym samym dniu
          // aby uniknąć grupowania powiadomień przez system
          var scheduledHour = hour;
          var scheduledMinute = minute + delayMinutes;
          
          // Jeśli minuty przekraczają 59, przenieś do następnej godziny
          if (scheduledMinute >= 60) {
            scheduledHour = (scheduledHour + 1) % 24;
            scheduledMinute = scheduledMinute % 60;
          }

          var scheduledTime = tz.TZDateTime(
            tz.local,
            targetDate.year,
            targetDate.month,
            targetDate.day,
            scheduledHour,
            scheduledMinute,
          );

          if (kDebugMode && dayOffset == 0) {
            debugPrint('    ⏰ Planowanie powiadomienia:');
            debugPrint('      Bazowa godzina: $hour:$minute');
            debugPrint('      Delay: $delayMinutes min');
            debugPrint('      Zaplanowany czas (przed korektą): ${scheduledTime.day}.${scheduledTime.month}.${scheduledTime.year} ${scheduledHour.toString().padLeft(2, '0')}:${scheduledMinute.toString().padLeft(2, '0')}');
            debugPrint('      Aktualny czas: ${now.day}.${now.month}.${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}');
            debugPrint('      Czy czas minął: ${scheduledTime.isBefore(now)}');
          }

          // Jeśli to dzisiaj, upewnij się, że powiadomienie jest zaplanowane co najmniej 5 minut w przyszłości
          // iOS może odrzucać powiadomienia zaplanowane zbyt blisko aktualnego czasu
          // Zawsze dodajemy minimum 5 minut dla powiadomień na dzisiaj, aby iOS je zaakceptował
          if (dayOffset == 0) {
            final timeDifference = scheduledTime.difference(now);
            // Jeśli różnica jest mniejsza niż 5 minut LUB powiadomienie jest w przeszłości
            if (timeDifference.inSeconds < 300 || scheduledTime.isBefore(now)) {
              scheduledTime = now.add(const Duration(minutes: 5));
              scheduledHour = scheduledTime.hour;
              scheduledMinute = scheduledTime.minute;
              
              if (kDebugMode) {
                debugPrint('    ⏰ Korekta czasu dla iOS - przesuwam na ${scheduledTime.day}.${scheduledTime.month}.${scheduledTime.year} ${scheduledHour.toString().padLeft(2, '0')}:${scheduledMinute.toString().padLeft(2, '0')} (min. 5 min w przyszłości)');
              }
            }
          }
          
          // Dodatkowa walidacja - jeśli zaplanowany czas jest w przeszłości, przesuń na przyszłość
          if (scheduledTime.isBefore(now)) {
            scheduledTime = now.add(const Duration(minutes: 5));
            scheduledHour = scheduledTime.hour;
            scheduledMinute = scheduledTime.minute;
    
    if (kDebugMode) {
              debugPrint('    ⚠️ Ostateczna korekta - przesuwam na ${scheduledTime.day}.${scheduledTime.month}.${scheduledTime.year} ${scheduledHour.toString().padLeft(2, '0')}:${scheduledMinute.toString().padLeft(2, '0')}');
            }
          }

          // Generuj unikalne ID na podstawie hash lokalizacji i daty
          // Używamy hash, aby uniknąć konfliktów i problemów z sekwencyjnymi ID na iOS
          final locationHash = location.id.hashCode.abs();
          final dateHash = targetDate.millisecondsSinceEpoch.hashCode.abs();
          final uniqueId = baseNotificationId + (locationHash % 100) + (dateHash % 1000);

          // Utwórz tytuł powiadomienia
          final locationName = location.name.isNotEmpty ? location.name : location.address.fullAddress;
          final notificationTitle = '$locationName - 🗑️✨ Ekipa już w gotowości!';

          if (kDebugMode && dayOffset == 0) {
            debugPrint('    📤 Wysyłam powiadomienie ID: $uniqueId');
            debugPrint('      Tytuł: $notificationTitle');
            debugPrint('      Treść: $notificationBody');
            debugPrint('      Ostateczny czas: ${scheduledTime.day}.${scheduledTime.month}.${scheduledTime.year} ${scheduledHour.toString().padLeft(2, '0')}:${scheduledMinute.toString().padLeft(2, '0')}');
          }

          try {
    await _notifications.zonedSchedule(
              uniqueId,
              notificationTitle,
              notificationBody,
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'waste_reminder',
          'Przypomnienia o odpadach',
                  channelDescription: 'Przypomnienia o odbiorze odpadów',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: scheduleMode,
              payload: '${location.id}|${targetDate.toIso8601String()}',
            );

            scheduledCount++;
            locationScheduledCount++;
            
            // Dla powiadomień na dzisiaj, sprawdź natychmiast czy są w systemie
            if (kDebugMode && dayOffset == 0) {
              debugPrint('    ✅ Powiadomienie zaplanowane pomyślnie (ID: $uniqueId)');
              
              // Sprawdź natychmiast czy powiadomienie jest w systemie
              final pendingCheck = await _notifications.pendingNotificationRequests();
              final foundInSystem = pendingCheck.any((n) => n.id == uniqueId);
              
              if (!foundInSystem) {
                debugPrint('    ⚠️ UWAGA: Powiadomienie ID: $uniqueId NIE JEST w systemie iOS po zaplanowaniu!');
                debugPrint('      To może oznaczać, że iOS odrzucił to powiadomienie.');
              } else {
                debugPrint('    ✅ Powiadomienie ID: $uniqueId jest w systemie iOS');
              }
            } else if (kDebugMode && dayOffset < 7) {
              debugPrint('    ✅ Zaplanowano powiadomienie ID: $uniqueId na ${scheduledTime.day}.${scheduledTime.month}.${scheduledTime.year} ${scheduledHour.toString().padLeft(2, '0')}:${scheduledMinute.toString().padLeft(2, '0')}');
            }
          } catch (e) {
    if (kDebugMode) {
              debugPrint('    ❌ BŁĄD podczas planowania powiadomienia ID: $uniqueId');
              debugPrint('      Błąd: $e');
              if (dayOffset == 0) {
                debugPrint('      ⚠️ To powiadomienie było na dzisiaj dla lokalizacji "${location.name}"!');
              }
            }
            // Nie zwiększamy scheduledCount, bo powiadomienie nie zostało zaplanowane
          }

          if (kDebugMode && dayOffset < 7) {
            debugPrint('    ✅ Zaplanowano powiadomienie ID: $uniqueId na ${scheduledTime.day}.${scheduledTime.month}.${scheduledTime.year} ${scheduledHour.toString().padLeft(2, '0')}:${scheduledMinute.toString().padLeft(2, '0')}');
          }
        }

        // Na końcu planuj powiadomienia na dzisiaj (dayOffset = 0)
        // To zapewnia, że powiadomienia na dzisiaj nie zostaną odrzucone przez iOS
        final todayDate = now;
        final todayDay = todayDate.day;
        final todayMonthKey = _getMonthKey(todayDate.month);
        final collectionsForToday = schedule.where((collection) {
          return collection.day == todayDay && 
                 collection.month.toLowerCase() == todayMonthKey.toLowerCase();
        }).toList();

        if (collectionsForToday.isNotEmpty) {
          if (kDebugMode) {
            debugPrint('  🔍 DZISIAJ (${todayDate.day}.${todayDate.month}.${todayDate.year}):');
            debugPrint('    Szukam: dzień=$todayDay, miesiąc=$todayMonthKey');
            debugPrint('    Znaleziono zbiórek: ${collectionsForToday.length}');
          }

          // Utwórz tekst powiadomienia z nowym formatem
          final wasteTypes = collectionsForToday
              .map((c) => c.originalTypeName)
              .toSet()
              .toList();
          
          String frakcjaText;
          if (wasteTypes.length == 1) {
            frakcjaText = wasteTypes.first;
          } else {
            frakcjaText = wasteTypes.join(', ');
          }
          final notificationBody = 
              'Dziś zabieramy $frakcjaText. Nie zapomnij wystawić pojemnika – nie lubi czekać! 😄';

          // Klucz dla dnia (używamy do śledzenia liczby powiadomień)
          final dayKey = '${todayDate.year}-${todayDate.month}-${todayDate.day}';
          final delayMinutes = notificationsPerDay[dayKey] ?? 0;
          notificationsPerDay[dayKey] = delayMinutes + 1;

          // Zaplanuj powiadomienie na wybraną godzinę w dniu zbiórki
          var scheduledHour = hour;
          var scheduledMinute = minute + delayMinutes;
          
          // Jeśli minuty przekraczają 59, przenieś do następnej godziny
          if (scheduledMinute >= 60) {
            scheduledHour = (scheduledHour + 1) % 24;
            scheduledMinute = scheduledMinute % 60;
          }

          var scheduledTime = tz.TZDateTime(
      tz.local,
            todayDate.year,
            todayDate.month,
            todayDate.day,
            scheduledHour,
            scheduledMinute,
    );

    if (kDebugMode) {
            debugPrint('    ⏰ Planowanie powiadomienia na dzisiaj:');
            debugPrint('      Bazowa godzina: $hour:$minute');
            debugPrint('      Delay: $delayMinutes min');
            debugPrint('      Zaplanowany czas (przed korektą): ${scheduledTime.day}.${scheduledTime.month}.${scheduledTime.year} ${scheduledHour.toString().padLeft(2, '0')}:${scheduledMinute.toString().padLeft(2, '0')}');
            debugPrint('      Aktualny czas: ${now.day}.${now.month}.${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}');
            debugPrint('      Czy czas minął: ${scheduledTime.isBefore(now)}');
          }

          // Upewnij się, że powiadomienie jest zaplanowane co najmniej 5 minut w przyszłości
          final timeDifference = scheduledTime.difference(now);
          if (timeDifference.inSeconds < 300 || scheduledTime.isBefore(now)) {
            scheduledTime = now.add(const Duration(minutes: 5));
            scheduledHour = scheduledTime.hour;
            scheduledMinute = scheduledTime.minute;
            
            if (kDebugMode) {
              debugPrint('    ⏰ Korekta czasu dla iOS - przesuwam na ${scheduledTime.day}.${scheduledTime.month}.${scheduledTime.year} ${scheduledHour.toString().padLeft(2, '0')}:${scheduledMinute.toString().padLeft(2, '0')} (min. 5 min w przyszłości)');
            }
          }

          // Generuj unikalne ID na podstawie hash lokalizacji i daty
          final locationHash = location.id.hashCode.abs();
          final dateHash = todayDate.millisecondsSinceEpoch.hashCode.abs();
          final uniqueId = baseNotificationId + (locationHash % 100) + (dateHash % 1000);

          // Utwórz tytuł powiadomienia
          final locationName = location.name.isNotEmpty ? location.name : location.address.fullAddress;
          final notificationTitle = '$locationName - 🗑️✨ Ekipa już w gotowości!';

          if (kDebugMode) {
            debugPrint('    📤 Wysyłam powiadomienie na dzisiaj ID: $uniqueId');
            debugPrint('      Tytuł: $notificationTitle');
            debugPrint('      Treść: $notificationBody');
            debugPrint('      Ostateczny czas: ${scheduledTime.day}.${scheduledTime.month}.${scheduledTime.year} ${scheduledHour.toString().padLeft(2, '0')}:${scheduledMinute.toString().padLeft(2, '0')}');
          }

          try {
            await _notifications.zonedSchedule(
              uniqueId,
              notificationTitle,
              notificationBody,
              scheduledTime,
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'waste_reminder',
                  'Przypomnienia o odpadach',
                  channelDescription: 'Przypomnienia o odbiorze odpadów',
                  importance: Importance.high,
                  priority: Priority.high,
                  icon: '@mipmap/ic_launcher',
                ),
                iOS: DarwinNotificationDetails(
                  presentAlert: true,
                  presentBadge: true,
                  presentSound: true,
                ),
              ),
              androidScheduleMode: scheduleMode,
              payload: '${location.id}|${todayDate.toIso8601String()}',
            );

            scheduledCount++;
            locationScheduledCount++;
            
            if (kDebugMode) {
              debugPrint('    ✅ Powiadomienie na dzisiaj zaplanowane pomyślnie (ID: $uniqueId)');
              
              // Sprawdź natychmiast czy powiadomienie jest w systemie
              final pendingCheck = await _notifications.pendingNotificationRequests();
              final foundInSystem = pendingCheck.any((n) => n.id == uniqueId);
              
              if (!foundInSystem) {
                debugPrint('    ⚠️ UWAGA: Powiadomienie ID: $uniqueId NIE JEST w systemie iOS po zaplanowaniu!');
                debugPrint('      To może oznaczać, że iOS odrzucił to powiadomienie.');
              } else {
                debugPrint('    ✅ Powiadomienie ID: $uniqueId jest w systemie iOS');
              }
            }
          } catch (e) {
      if (kDebugMode) {
              debugPrint('    ❌ BŁĄD podczas planowania powiadomienia na dzisiaj ID: $uniqueId');
              debugPrint('      Błąd: $e');
            }
            // Nie zwiększamy scheduledCount, bo powiadomienie nie zostało zaplanowane
      }
    } else {
      if (kDebugMode) {
            debugPrint('  🔍 DZISIAJ (${todayDate.day}.${todayDate.month}.${todayDate.year}):');
            debugPrint('    Szukam: dzień=$todayDay, miesiąc=$todayMonthKey');
            debugPrint('    Znaleziono zbiórek: 0');
            debugPrint('    ⚠️ BRAK ZBIÓREK DZISIAJ dla lokalizacji "${location.name}"');
          }
        }

        if (kDebugMode) {
          debugPrint('✅ Lokalizacja "${location.name}": zaplanowano $locationScheduledCount powiadomień');
          if (locationScheduledCount == 0) {
            debugPrint('  ⚠️ UWAGA: Brak powiadomień zaplanowanych dla tej lokalizacji w najbliższych 60 dniach!');
          }
          
          // Sprawdź, czy powiadomienie na dzisiaj dla tej lokalizacji jest nadal w systemie
          final pendingAfterLocation = await _notifications.pendingNotificationRequests();
          final locationName = location.name.isNotEmpty ? location.name : location.address.fullAddress;
          final expectedTitle = '$locationName - 🗑️✨ Ekipa już w gotowości!';
          final todayNotificationForLocation = pendingAfterLocation.where((n) {
            if (n.title != expectedTitle) {
              return false;
            }
            if (n.payload == null) return false;
            try {
              final parts = n.payload!.split('|');
              if (parts.length < 2) return false;
              final notificationDate = DateTime.parse(parts[1]);
              final today = DateTime.now();
              return notificationDate.year == today.year &&
                     notificationDate.month == today.month &&
                     notificationDate.day == today.day;
            } catch (e) {
              return false;
            }
          }).toList();
          
          if (todayNotificationForLocation.isEmpty) {
            debugPrint('  ⚠️ UWAGA: Powiadomienie na dzisiaj dla lokalizacji "${location.name}" NIE JEST w systemie po zakończeniu planowania!');
          } else {
            debugPrint('  ✅ Powiadomienie na dzisiaj dla lokalizacji "${location.name}" jest w systemie (ID: ${todayNotificationForLocation.first.id})');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('Błąd planowania powiadomień dla lokalizacji "${location.name}": $e');
        }
      }
    }

    if (kDebugMode) {
      debugPrint('Zaplanowano łącznie $scheduledCount powiadomień');
      debugPrint('===============================================');
      
      // Sprawdź zaplanowane powiadomienia i wyświetl szczegóły
      final pending = await _notifications.pendingNotificationRequests();
      debugPrint('=== WERYFIKACJA ZAPLANOWANYCH POWIADOMIEŃ ===');
      debugPrint('Liczba zaplanowanych powiadomień w systemie: ${pending.length}');
      
      // Grupuj powiadomienia według lokalizacji
      final Map<String, List<PendingNotificationRequest>> byLocation = {};
      for (final notification in pending) {
        final locationName = notification.title ?? 'Bez nazwy';
        if (!byLocation.containsKey(locationName)) {
          byLocation[locationName] = [];
        }
        byLocation[locationName]!.add(notification);
      }
      
      for (final entry in byLocation.entries) {
        debugPrint('  📍 ${entry.key}: ${entry.value.length} powiadomień');
        // Pokaż pierwsze 3 powiadomienia dla każdej lokalizacji
        for (int i = 0; i < entry.value.length && i < 3; i++) {
          final notif = entry.value[i];
          debugPrint('    - ID: ${notif.id}, Czas: ${notif.body?.substring(0, notif.body!.length > 50 ? 50 : notif.body!.length)}...');
        }
      }
      
      // Sprawdź, czy wszystkie lokalizacje mają powiadomienia
      for (final location in enabledLocations) {
        final locationName = location.name.isNotEmpty ? location.name : location.address.fullAddress;
        final expectedTitle = '$locationName - 🗑️✨ Ekipa już w gotowości!';
        final hasNotifications = byLocation.containsKey(expectedTitle);
        if (!hasNotifications) {
          debugPrint('  ⚠️ UWAGA: Lokalizacja "$locationName" NIE MA zaplanowanych powiadomień!');
        } else {
          // Sprawdź, czy powiadomienie na dzisiaj jest w systemie
          // Używamy payload, który zawiera datę w formacie ISO8601
          final today = DateTime.now();
          final todayNotifications = byLocation[expectedTitle]!.where((n) {
            if (n.payload == null) return false;
            try {
              // Payload ma format: "locationId|ISO8601Date"
              final parts = n.payload!.split('|');
              if (parts.length < 2) return false;
              final notificationDate = DateTime.parse(parts[1]);
              // Sprawdź, czy powiadomienie jest na dzisiaj (ten sam dzień)
              return notificationDate.year == today.year &&
                     notificationDate.month == today.month &&
                     notificationDate.day == today.day;
            } catch (e) {
              return false;
            }
          }).toList();
          
          if (todayNotifications.isEmpty) {
            debugPrint('  ⚠️ UWAGA: Lokalizacja "$locationName" nie ma powiadomienia na dzisiaj w systemie!');
          } else {
            debugPrint('  ✅ Lokalizacja "$locationName" ma ${todayNotifications.length} powiadomienie(ń) na dzisiaj');
            for (final notif in todayNotifications) {
              try {
                final parts = notif.payload!.split('|');
                final notificationDate = DateTime.parse(parts[1]);
                debugPrint('    - ID: ${notif.id}, Tytuł: ${notif.title}, Data: ${notificationDate.day}.${notificationDate.month}.${notificationDate.year}');
              } catch (e) {
                debugPrint('    - ID: ${notif.id}, Tytuł: ${notif.title}');
              }
            }
          }
        }
      }
      
      // Sprawdź różnicę między zaplanowanymi a faktycznie w systemie
      final missingCount = scheduledCount - pending.length;
      if (missingCount > 0) {
        debugPrint('  ⚠️ UWAGA: $missingCount powiadomień zostało odrzuconych przez iOS!');
        debugPrint('    Zaplanowano: $scheduledCount, W systemie: ${pending.length}');
      }
      
      debugPrint('===============================================');
    }
  }

  /// Zwraca klucz miesiąca dla lokalizacji (jak w WasteCollection)
  static String _getMonthKey(int month) {
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


  /// Anuluje wszystkie zaplanowane powiadomienia
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Wysyła natychmiastowe powiadomienie o odpadach na dzisiaj
  static Future<void> sendTodayWasteNotification(Address address) async {
    if (!await areNotificationsEnabled()) return;

    try {
      // Pobierz harmonogram dla dzisiaj
      final today = DateTime.now();

      // Sprawdź czy mamy pełne dane adresu
      if (address.prefix == null || address.propertyNumber == null) {
        debugPrint('Brak pełnych danych adresu dla powiadomienia');
        return;
      }

      // Użyj rzeczywistych wartości z adresu
      final schedule = await _apiService.getWasteSchedule(
        address.prefix!,
        address.propertyNumber!,
      );

      // Znajdź odpady na dzisiaj
      final todayCollections = schedule
          .where((collection) => collection.day == today.day)
          .toList();

      if (todayCollections.isEmpty) return;

      const String title = 'Odpady na dzisiaj';
      String body = 'Dzisiaj odbiera się: ';

      if (todayCollections.length == 1) {
        body += todayCollections.first.originalTypeName;
      } else {
        body += todayCollections.map((c) => c.originalTypeName).join(', ');
      }

      await _notifications.show(
        1, // ID powiadomienia
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'waste_today',
            'Odpady na dzisiaj',
            channelDescription: 'Powiadomienia o odpadach na dzisiaj',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Błąd wysyłania powiadomienia o odpadach: $e');
    }
  }


  /// Sprawdza i aktualizuje powiadomienia na podstawie ustawień
  static Future<void> updateNotifications() async {
    if (await areNotificationsEnabled()) {
      await scheduleDailyWasteNotification();
    } else {
      await cancelAllNotifications();
    }
  }

  /// Wysyła testowe powiadomienie natychmiast
  static Future<void> sendTestNotification() async {
    try {
      if (kDebugMode) {
        debugPrint('=== WYSYŁANIE TESTOWEGO POWIADOMIENIA ===');
        debugPrint('Platforma: ${Platform.isIOS ? "iOS" : "Android"}');
        debugPrint('Serwis zainicjalizowany: $_isInitialized');
      }
      
      // Sprawdź czy serwis jest zainicjalizowany
      if (!_isInitialized) {
        if (kDebugMode) {
          debugPrint('Inicjalizuję serwis powiadomień...');
        }
        await initialize();
      }
      
      // Sprawdź uprawnienia na iOS
      if (Platform.isIOS) {
        final iosPlugin = _notifications.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
        if (iosPlugin != null) {
          final permissions = await iosPlugin.checkPermissions();
          if (kDebugMode) {
            debugPrint('Uprawnienia iOS:');
            debugPrint('  Enabled: ${permissions?.isEnabled}');
            debugPrint('  Alert: ${permissions?.isAlertEnabled}');
            debugPrint('  Badge: ${permissions?.isBadgeEnabled}');
            debugPrint('  Sound: ${permissions?.isSoundEnabled}');
          }
          
          // Jeśli brak uprawnień, poproś o nie
          if (permissions?.isEnabled != true || permissions?.isAlertEnabled != true || permissions?.isBadgeEnabled != true || permissions?.isSoundEnabled != true) {
            if (kDebugMode) {
              debugPrint('Brak uprawnień - proszę o uprawnienia...');
            }
            await iosPlugin.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
          }
        }
      }
      
      if (kDebugMode) {
        debugPrint('Wysyłam powiadomienie...');
      }
      
      await _notifications.show(
        999, // ID testowego powiadomienia
        'Test powiadomienia',
        'To jest testowe powiadomienie z aplikacji KOMA',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'test_channel',
            'Testowe powiadomienia',
            channelDescription: 'Testowe powiadomienia do sprawdzenia działania',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            enableVibration: true,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
      
      if (kDebugMode) {
        debugPrint('Testowe powiadomienie wysłane pomyślnie');
        debugPrint('==========================================');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Błąd wysyłania testowego powiadomienia: $e');
        debugPrint('Stack trace: ${StackTrace.current}');
      }
      rethrow;
    }
  }

  /// Sprawdza zaplanowane powiadomienia
  static Future<List<PendingNotificationRequest>>
  getPendingNotifications() async {
    final pending = await _notifications.pendingNotificationRequests();
    
    if (kDebugMode) {
      debugPrint('=== ZAPLANOWANE POWIADOMIENIA ===');
      debugPrint('Liczba zaplanowanych powiadomień: ${pending.length}');
      for (final notification in pending) {
        debugPrint('  ID: ${notification.id}, Tytuł: ${notification.title}');
      }
      debugPrint('==================================');
    }
    
    return pending;
  }

  /// Planuje powiadomienie na konkretny czas (dla testów)
  static Future<void> scheduleTestNotification(DateTime dateTime) async {
    final tzDate = tz.TZDateTime.from(dateTime, tz.local);

    await _notifications.zonedSchedule(
      998, // ID testowego powiadomienia
      'Test zaplanowanego powiadomienia',
      'To powiadomienie zostało zaplanowane na ${dateTime.toString()}',
      tzDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_scheduled',
          'Zaplanowane testy',
          channelDescription: 'Testowe zaplanowane powiadomienia',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
