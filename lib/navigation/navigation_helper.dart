import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';

/// Helper do zarządzania nawigacją w aplikacji
class NavigationHelper {
  /// Nawigacja z bottom navigation bar (6 ikon)
  /// [0] Harmonogram [1] Baza wiedzy [2] Sklep [3] BOK [4] Powiadomienia [5] Ustawienia
  static void navigateFromBottomNav(
    BuildContext context,
    int index,
    int currentIndex,
  ) {
    // Jeśli już jesteśmy na tym ekranie, nic nie rób
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        // Harmonogram - przejdź bezpośrednio do harmonogramu (jeśli jest zapisany adres)
        // lub do wyboru adresu jeśli nie ma zapisanego
        Navigator.pushReplacementNamed(context, '/main-schedule');
        break;
      case 1:
        // Baza wiedzy o odpadach
        Navigator.pushReplacementNamed(context, '/waste-search');
        break;
      case 2:
        // Sklep KOMA - external link
        _launchExternalUrl(
          context,
          'https://sklep.koma.pl/',
          AppLocalizations.of(context)!.shop,
        );
        break;
      case 3:
        // BOK Portal - external link
        _launchExternalUrl(
          context,
          'https://bok.koma.pl/',
          AppLocalizations.of(context)!.bokPortal,
        );
        break;
      case 4:
        // Powiadomienia - nie zaimplementowane
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.notificationsComingSoon,
            ),
            duration: const Duration(seconds: 2),
          ),
        );
        break;
      case 5:
        // Ustawienia
        Navigator.pushReplacementNamed(context, '/settings');
        break;
    }
  }

  /// Obsługa zewnętrznych linków dla nowego systemu nawigacji
  static void handleExternalNavigation(BuildContext context, int index) {
    final l10n = AppLocalizations.of(context)!;

    switch (index) {
      case 2:
        // Sklep KOMA - external link
        _launchExternalUrl(context, 'https://sklep.koma.pl/', l10n.shop);
        break;
      case 3:
        // BOK Portal - external link
        _launchExternalUrl(context, 'https://bok.koma.pl/', l10n.bokPortal);
        break;
      case 4:
        // Powiadomienia - nie zaimplementowane
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.notificationsComingSoon),
            duration: const Duration(seconds: 2),
          ),
        );
        break;
    }
  }

  /// Otwiera zewnętrzny URL w przeglądarce (publiczna metoda)
  static Future<void> launchExternalUrl(
    BuildContext context,
    String url,
    String name,
  ) async {
    await _launchExternalUrl(context, url, name);
  }

  /// Otwiera zewnętrzny URL w przeglądarce (prywatna metoda)
  static Future<void> _launchExternalUrl(
    BuildContext context,
    String url,
    String name,
  ) async {
    final Uri uri = Uri.parse(url);
    final l10n = AppLocalizations.of(context)!;

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n.error}: ${l10n.unknownError}'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.error}: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  /// Nawigacja do harmonogramu z adresem
  static void navigateToSchedule(BuildContext context, dynamic address) {
    Navigator.pushNamed(context, '/waste-schedule', arguments: address);
  }

  /// Nawigacja do szczegółów odpadów
  static void navigateToWasteDetails(
    BuildContext context,
    List<dynamic> collections,
  ) {
    Navigator.pushNamed(context, '/waste-details', arguments: collections);
  }

  /// Nawigacja wstecz
  static void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }
}
