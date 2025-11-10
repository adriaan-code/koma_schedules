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

  /// Ustawia codzienne powiadomienie o odpadach
  static Future<void> scheduleDailyWasteNotification() async {
    if (kDebugMode) {
      debugPrint('=== PLANOWANIE CODZIENNEGO POWIADOMIENIA ===');
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

    // Wybierz tryb planowania na podstawie uprawnień
    final canScheduleExact = await canScheduleExactAlarms();
    final scheduleMode = canScheduleExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;
    
    if (kDebugMode) {
      debugPrint('Tryb planowania: ${canScheduleExact ? "dokładny" : "przybliżony"}');
    }

    final scheduledTime = _nextInstanceOfTime(hour, minute);
    
    if (kDebugMode) {
      debugPrint('Zaplanowano na: $scheduledTime');
    }

    // Ustaw nowe powiadomienie
    await _notifications.zonedSchedule(
      0, // ID powiadomienia
      'Przypomnienie o odpadach',
      'Sprawdź harmonogram odbioru odpadów na dzisiaj',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'waste_reminder',
          'Przypomnienia o odpadach',
          channelDescription: 'Codzienne przypomnienia o odbiorze odpadów',
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
      matchDateTimeComponents: DateTimeComponents.time,
    );
    
    if (kDebugMode) {
      debugPrint('Codzienne powiadomienie zaplanowane pomyślnie');
      debugPrint('===============================================');
    }
  }

  /// Oblicza następny czas dla powiadomienia
  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (kDebugMode) {
      debugPrint('Obliczanie czasu powiadomienia:');
      debugPrint('  Aktualny czas: $now');
      debugPrint('  Docelowa godzina: $hour:$minute');
      debugPrint('  Zaplanowany czas (dzisiaj): $scheduledDate');
    }

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
      if (kDebugMode) {
        debugPrint('  Czas już minął - przesuwam na jutro: $scheduledDate');
      }
    } else {
      if (kDebugMode) {
        debugPrint('  Czas jeszcze nie minął - zostawiam dzisiaj: $scheduledDate');
      }
    }

    return scheduledDate;
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
