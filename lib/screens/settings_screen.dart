import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../services/settings_service.dart';
import '../services/notification_service.dart';
import '../widgets/koma_header.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, this.onLanguageChanged});
  final void Function(String)? onLanguageChanged;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsService _settingsService = SettingsService();
  bool _notificationsEnabled = true;
  TimeOfDay _notificationTime = const TimeOfDay(hour: 7, minute: 0);
  bool _locationAccess = false;
  String _selectedLanguage = 'Polski';
  bool _isLoading = true;
  bool _languageExpanded = false;

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _initializeNotifications();
  }

  /// Inicjalizuje powiadomienia przy starcie ekranu
  Future<void> _initializeNotifications() async {
    await NotificationService.updateNotifications();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.backgroundWhite,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header z logo KOMA
              KomaHeader.logoOnly(),

              //const SizedBox(height: 40),
              // Tytuł "USTAWIENIA"
              Center(
                child: Text(
                  AppLocalizations.of(context)!.settings,
                  style: const TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                    color: AppTheme.textBlack,
                  ),
                ),
              ),
            const SizedBox(height: 40),

            // Lista ustawień w stylu z obrazka
            _buildSettingsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
        // Przypomnienie
        _buildSettingRow(
          icon: Icons.alarm_outlined,
          title: AppLocalizations.of(context)!.reminder,
          control: Semantics(
            label:
                'Powiadomienia ${_notificationsEnabled ? "włączone" : "wyłączone"}',
            hint:
                'Dotknij aby ${_notificationsEnabled ? "wyłączyć" : "włączyć"} przypomnienia',
            child: Switch(
              value: _notificationsEnabled,
              onChanged: (value) async {
                if (value) {
                  // Automatycznie proś o uprawnienia do powiadomień
                  await NotificationService.requestNotificationPermission();
                }

                setState(() {
                  _notificationsEnabled = value;
                });
                await _settingsService.setNotificationsEnabled(value);

                // Aktualizuj powiadomienia
                await NotificationService.updateNotifications();
              },
              activeThumbColor: AppTheme.primaryBlue,
            ),
          ),
        ),

        // Godzina powiadomień (tylko jeśli przypomnienie jest włączone)
        if (_notificationsEnabled) ...[
          _buildSettingRow(
            icon: Icons.access_time,
            title: AppLocalizations.of(context)!.notificationTime,
            control: GestureDetector(
              onTap: _selectTime,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                  border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.3)),
                ),
                child: Text(
                  _notificationTime.format(context),
                  style: const TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          
          // Test powiadomień
          _buildSettingRow(
            icon: Icons.notifications_active,
            title: AppLocalizations.of(context)!.testNotifications,
            control: ElevatedButton(
              onPressed: () async {
                try {
                  await NotificationService.sendTestNotification();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!.testNotificationSent),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${AppLocalizations.of(context)!.error}: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: Text(AppLocalizations.of(context)!.test),
            ),
          ),
          
          // Sprawdź zaplanowane powiadomienia
          _buildSettingRow(
            icon: Icons.schedule,
            title: AppLocalizations.of(context)!.scheduledNotifications,
            control: ElevatedButton(
              onPressed: () async {
                try {
                  final pending = await NotificationService.getPendingNotifications();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${AppLocalizations.of(context)!.scheduledNotifications}: ${pending.length}'),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${AppLocalizations.of(context)!.error}: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: Text(AppLocalizations.of(context)!.check),
            ),
          ),
        ],

        // Dostęp do lokalizacji
        _buildSettingRow(
          icon: Icons.location_on_outlined,
          title: AppLocalizations.of(context)!.locationAccess,
          control: Semantics(
            label:
                'Dostęp do lokalizacji ${_locationAccess ? "włączony" : "wyłączony"}',
            hint:
                'Dotknij aby ${_locationAccess ? "wyłączyć" : "włączyć"} dostęp do lokalizacji',
            child: Switch(
              value: _locationAccess,
              onChanged: (value) async {
                if (value) {
                  // Sprawdź uprawnienia do lokalizacji
                  final status = await Permission.location.request();
                  if (!status.isGranted) {
                    _showPermissionDialog('lokalizacji');
                    return;
                  }
                }

                setState(() {
                  _locationAccess = value;
                });
                await _settingsService.setLocationAccess(value);
              },
              activeThumbColor: AppTheme.primaryBlue,
            ),
          ),
        ),

        // Język
        _buildLanguageSection(),

        // Informacje o aplikacji
        _buildSettingRow(
          icon: Icons.info_outline,
          title: AppLocalizations.of(context)!.appVersion,
          control: const Text(
            '1.0.0',
            style: TextStyle(
              color: AppTheme.grey600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        _buildSettingRow(
          icon: Icons.copyright,
          title: AppLocalizations.of(context)!.copyright,
          control: const Text(
            '© 2025 KOMA',
            style: TextStyle(
              color: AppTheme.grey600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ],
      ),
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required String title,
    required Widget control,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: const BoxDecoration(
        color: AppTheme.backgroundGreyLight,
        border: Border(
          left: BorderSide(color: AppTheme.textBlack, width: 4),
          right: BorderSide(color: AppTheme.textBlack, width: 4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            // Ikona po lewej stronie
            Icon(icon, color: AppTheme.primaryBlue, size: 24),
            const SizedBox(width: 16),

            // Tytuł w środku
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textBlack,
                ),
              ),
            ),

            // Kontrolka po prawej stronie
            control,
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSection() {
    final List<String> languages = ['Polski', 'English', 'Українська'];
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: const BoxDecoration(
        color: AppTheme.backgroundGreyMedium,
        border: Border(
          left: BorderSide(color: AppTheme.textBlack, width: 4),
          right: BorderSide(color: AppTheme.textBlack, width: 4),
        ),
      ),
      child: Column(
        children: [
          Semantics(
            button: true,
            label: AppLocalizations.of(context)!.language,
            hint: _languageExpanded
                ? 'Dotknij aby zwinąć wybór języka'
                : 'Dotknij aby rozwinąć wybór języka',
            child: InkWell(
              onTap: () {
                setState(() {
                  _languageExpanded = !_languageExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.language, color: AppTheme.primaryBlue, size: 24),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.language,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textBlack,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                        border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _selectedLanguage,
                            style: const TextStyle(
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Icon(
                            _languageExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            color: AppTheme.primaryBlue,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedCrossFade(
            crossFadeState:
                _languageExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 8,
                runSpacing: 8,
                children: languages.map((lang) {
                  final bool isSelected = lang == _selectedLanguage;
                  return Semantics(
                    button: true,
                    selected: isSelected,
                    label: 'Wybierz język: $lang',
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          _selectedLanguage = lang;
                        });
                        await _settingsService.setSelectedLanguage(lang);
                        final languageCode = await _settingsService.getLanguageCode();
                        widget.onLanguageChanged?.call(languageCode);
                      },
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppTheme.backgroundGreyMedium,
                              borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                              border: Border.all(
                                color: isSelected ? AppTheme.primaryBlue : AppTheme.grey500,
                                width: isSelected ? 3 : 1,
                              ),
                            ),
                            child: Text(
                              lang,
                              style: TextStyle(
                                color: AppTheme.textBlack,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Positioned(
                              right: 4,
                              top: 4,
                              child: Icon(
                                Icons.check_circle,
                                size: 16,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadSettings() async {
    final notificationsEnabled = await _settingsService.notificationsEnabled;
    final locationAccess = await _settingsService.locationAccess;
    final selectedLanguage = await _settingsService.selectedLanguage;
    final hour = await _settingsService.notificationHour;
    final minute = await _settingsService.notificationMinute;

    setState(() {
      _notificationsEnabled = notificationsEnabled;
      _locationAccess = locationAccess;
      _selectedLanguage = selectedLanguage;
      _notificationTime = TimeOfDay(hour: hour, minute: minute);
      _isLoading = false;
    });
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _notificationTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppTheme.primaryBlue),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _notificationTime) {
      setState(() {
        _notificationTime = picked;
      });
      await _settingsService.setNotificationTime(picked.hour, picked.minute);

      // Aktualizuj powiadomienia z nową godziną
      await NotificationService.updateNotifications();
    }
  }

  /// Pokazuje dialog o uprawnieniach
  void _showPermissionDialog(String permissionType) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.permissionsRequired),
          content: Text(
            AppLocalizations.of(context)!.permissionMessage(permissionType),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: Text(AppLocalizations.of(context)!.openSettings),
            ),
          ],
        );
      },
    );
  }
}
