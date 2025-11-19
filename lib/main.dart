import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'screens/address_search_screen.dart';
import 'screens/waste_details_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/splash_screen.dart';
import 'models/address.dart';
import 'models/waste_collection.dart';
import 'services/notification_service.dart';
import 'services/settings_service.dart';
import 'services/connectivity_service.dart';
import 'services/wonderpush_service.dart';
import 'config/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  // Ustaw orientację na pionową
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Inicjalizuj serwis powiadomień
  try {
    await NotificationService.initialize();
  } catch (e) {
    debugPrint('Błąd inicjalizacji powiadomień: $e');
  }

  // Przygotuj WonderPush (powiadomienia push)
  try {
    await WonderPushService.initialize();
  } catch (e) {
    debugPrint('Błąd inicjalizacji WonderPush: $e');
  }

  // Inicjalizuj monitoring połączenia
  try {
    await ConnectivityService.initialize();
  } catch (e) {
    debugPrint('Błąd inicjalizacji connectivity: $e');
  }

  // Ustaw error boundary dla błędów Flutter
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };

  // Ustaw error boundary dla błędów asynchronicznych
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Async Error: $error');
    debugPrint('Stack trace: $stack');
    return true;
  };

  runApp(const KomaApp());
}

class KomaApp extends StatefulWidget {
  const KomaApp({super.key});

  @override
  State<KomaApp> createState() => _KomaAppState();
}

class _KomaAppState extends State<KomaApp> {
  final SettingsService _settingsService = SettingsService();
  Locale _currentLocale = const Locale('pl', '');
  bool _isLanguageLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    if (_isLanguageLoaded) return;

    final languageCode = await _settingsService.getLanguageCode();
    if (mounted) {
      setState(() {
        _currentLocale = Locale(languageCode, '');
        _isLanguageLoaded = true;
      });
    }
  }

  // Funkcja do zmiany języka na żywo
  void changeLanguage(String languageCode) {
    if (_currentLocale.languageCode != languageCode) {
      setState(() {
        _currentLocale = Locale(languageCode, '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KOMA App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getThemeData(),
      locale: _currentLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pl', ''), // Polski
        Locale('en', ''), // English
        Locale('uk', ''), // Українська
      ],
      // Używamy splash screen jako początkowy ekran
      initialRoute: '/splash',
      routes: {
        // Splash screen
        '/splash': (context) => const SplashScreen(),
        // Główny ekran z nowym systemem nawigacji
        '/main-navigation': (context) =>
            MainNavigationScreen(onLanguageChanged: changeLanguage),
        '/address-search': (context) =>
            AddressSearchScreen(onLanguageChanged: changeLanguage),
        '/waste-details': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args is List<WasteCollection>) {
            return WasteDetailsScreen(
              collections: args,
              onLanguageChanged: changeLanguage,
            );
          }
          return MainNavigationScreen(onLanguageChanged: changeLanguage);
        },
        '/settings': (context) =>
            MainNavigationScreen(onLanguageChanged: changeLanguage),
        '/waste-search': (context) =>
            MainNavigationScreen(onLanguageChanged: changeLanguage),
        // '/disposal-locations': (context) => const DisposalLocationsScreen(), // not used currently
        '/waste-schedule': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args is Address) {
            return MainNavigationScreen(
              onLanguageChanged: changeLanguage,
              initialAddress: args,
            );
          }
          return MainNavigationScreen(onLanguageChanged: changeLanguage);
        },
      },
      onGenerateRoute: (settings) {
        // Obsługa błędów routingu
        return MaterialPageRoute(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            return Scaffold(
              appBar: AppBar(title: Text(l10n.error)),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(l10n.pageNotFound(settings.name ?? '')),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.of(
                        context,
                      ).pushReplacementNamed('/main-navigation'),
                      child: Text(l10n.returnToMain),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

