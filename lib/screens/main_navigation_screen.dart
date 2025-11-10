import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../models/address.dart';
import '../screens/address_search_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/waste_schedule_screen.dart';
import '../screens/waste_search_screen.dart';
import '../services/location_history_service.dart';
import '../widgets/custom_bottom_navigation.dart';

/// Główny ekran aplikacji z statycznym bottom navigation i płynnymi przejściami
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({
    super.key,
    required this.onLanguageChanged,
    this.initialAddress,
  });

  final void Function(String) onLanguageChanged;
  final Address? initialAddress;

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _onBottomNavTap(int index) {
    if (index == _currentIndex) return;
    
    // Walidacja indeksu - maksymalnie 5 elementów (0-4)
    if (index < 0 || index > 4) return;

    // Sprawdź czy to zewnętrzny link (teraz tylko index 2)
    if (index == 2) {
      // Dropdown menu obsługuje nawigację wewnętrznie
      return;
    }

    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildScreen(int index) {
    Widget screen;

    switch (index) {
      case 0: // Harmonogram
        // Jeśli mamy initialAddress, użyj go
        if (widget.initialAddress != null) {
          screen = WasteScheduleScreen(
            selectedAddress: widget.initialAddress!,
            onLanguageChanged: widget.onLanguageChanged,
          );
        } else {
          // W przeciwnym razie sprawdź historię adresów
          screen = FutureBuilder<List<Address>>(
            future: LocationHistoryService.getRecentLocations(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final lastAddress = snapshot.data!.first;
                  return WasteScheduleScreen(
                    selectedAddress: lastAddress,
                    onLanguageChanged: widget.onLanguageChanged,
                  );
                }
              }
              return AddressSearchScreen(
                onLanguageChanged: widget.onLanguageChanged,
              );
            },
          );
        }
        break;
      case 1: // Baza wiedzy
        screen = const WasteSearchScreen();
        break;
      case 2: // Linki zewnętrzne - dropdown menu
        screen = _PlaceholderScreen(
          icon: Icons.more_horiz,
          title: AppLocalizations.of(context)!.externalLinks,
          subtitle: AppLocalizations.of(context)!.notificationsComingSoon,
        );
        break;
      case 3: // Powiadomienia - placeholder
        screen = _PlaceholderScreen(
          icon: Icons.notifications_outlined,
          title: AppLocalizations.of(context)!.notifications,
          subtitle: AppLocalizations.of(context)!.notificationsComingSoon,
        );
        break;
      case 4: // Ustawienia
        screen = SettingsScreen(onLanguageChanged: widget.onLanguageChanged);
        break;
      default:
        screen = _PlaceholderScreen(
          icon: Icons.error,
          title: AppLocalizations.of(context)!.error,
          subtitle: AppLocalizations.of(context)!.unknownError,
        );
    }

    return screen;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0.1, 0.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: child,
            ),
          );
        },
        child: _buildScreen(_currentIndex),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}

/// Placeholder screen dla ekranów w rozwoju
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.grey[400]),
            const SizedBox(height: AppTheme.spacingLarge),
            Text(
              title,
              style: const TextStyle(
                fontSize: AppTheme.fontSizeXLarge,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSmall),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: AppTheme.fontSizeMedium,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
