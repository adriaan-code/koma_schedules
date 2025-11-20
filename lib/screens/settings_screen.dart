import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../models/address.dart';
import '../models/saved_location.dart';
import '../services/settings_service.dart';
import '../services/notification_service.dart';
import '../widgets/koma_header.dart';
import 'address_search_screen.dart';
import 'package:uuid/uuid.dart';

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
  String _selectedLanguage = 'Polski';
  bool _isLoading = true;
  bool _languageExpanded = false;
  bool _locationsExpanded = false;
  List<SavedLocation> _savedLocations = [];

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
          // Sekcja lokalizacji dla przypomnień
          _buildLocationsSection(),
        ],


        // Język
        _buildLanguageSection(),

        // Informacje o aplikacji
        _buildSettingRow(
          icon: Icons.info_outline,
          title: AppLocalizations.of(context)!.appVersion,
          control: const Text(
            '1.0.1',
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
    final selectedLanguage = await _settingsService.selectedLanguage;
    final hour = await _settingsService.notificationHour;
    final minute = await _settingsService.notificationMinute;
    final savedLocations = await _settingsService.getSavedLocations();

    setState(() {
      _notificationsEnabled = notificationsEnabled;
      _selectedLanguage = selectedLanguage;
      _notificationTime = TimeOfDay(hour: hour, minute: minute);
      _savedLocations = savedLocations;
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


  /// Buduje sekcję lokalizacji dla przypomnień
  Widget _buildLocationsSection() {
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
            label: 'Lokalizacje dla przypomnień',
            hint: _locationsExpanded
                ? 'Dotknij aby zwinąć listę lokalizacji'
                : 'Dotknij aby rozwinąć listę lokalizacji',
            child: InkWell(
              onTap: () {
                setState(() {
                  _locationsExpanded = !_locationsExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.location_city, color: AppTheme.primaryBlue, size: 24),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Lokalizacje dla przypomnień',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textBlack,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                      ),
                      child: Text(
                        '${_savedLocations.length}',
                        style: const TextStyle(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      _locationsExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: AppTheme.primaryBlue,
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedCrossFade(
            crossFadeState:
                _locationsExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Przycisk dodaj lokalizację
                  ElevatedButton.icon(
                    onPressed: _addLocation,
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('Dodaj lokalizację'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Lista lokalizacji
                  if (_savedLocations.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Brak zapisanych lokalizacji. Dodaj lokalizację, aby otrzymywać przypomnienia o odpadach.',
                        style: TextStyle(
                          color: AppTheme.grey600,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    ..._savedLocations.map((location) => _buildLocationItem(location)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Buduje element lokalizacji
  Widget _buildLocationItem(SavedLocation location) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        border: Border.all(
          color: location.isEnabled ? AppTheme.primaryBlue : AppTheme.grey500,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.name.isNotEmpty ? location.name : 'Bez nazwy',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: location.isEnabled ? AppTheme.textBlack : AppTheme.grey600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location.address.fullAddress,
                    style: TextStyle(
                      fontSize: 14,
                      color: location.isEnabled ? AppTheme.grey600 : AppTheme.grey500,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: location.isEnabled,
              onChanged: (value) async {
                final updated = location.copyWith(isEnabled: value);
                await _settingsService.updateSavedLocation(updated);
                await _loadSettings();
                await NotificationService.updateNotifications();
              },
              activeThumbColor: AppTheme.primaryBlue,
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _deleteLocation(location),
            ),
          ],
        ),
      ),
    );
  }

  /// Dodaje nową lokalizację
  Future<void> _addLocation() async {
    // Przejdź do ekranu wyboru adresu
    final result = await Navigator.push<Address>(
      context,
      MaterialPageRoute<Address>(
        builder: (context) => AddressSearchScreen(
          onLanguageChanged: widget.onLanguageChanged,
          returnAddress: true,
        ),
      ),
    );

    if (result != null && result.prefix != null && result.propertyNumber != null) {
      // Poproś użytkownika o nazwę lokalizacji
      final name = await _showLocationNameDialog();
      if (name != null) {
        final newLocation = SavedLocation(
          id: const Uuid().v4(),
          address: result,
          name: name,
          isEnabled: true,
        );
        await _settingsService.addSavedLocation(newLocation);
        await _loadSettings();
        await NotificationService.updateNotifications();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Dodano lokalizację: $name'),
              backgroundColor: AppTheme.primaryBlue,
            ),
          );
        }
      }
    }
  }

  /// Pokazuje dialog do wprowadzenia nazwy lokalizacji
  Future<String?> _showLocationNameDialog() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nazwa lokalizacji'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'np. Dom, Działka, Biuro',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
              final name = controller.text.trim();
              Navigator.of(context).pop(name.isEmpty ? 'Lokalizacja' : name);
            },
            child: const Text('Dodaj'),
          ),
        ],
      ),
    );
  }

  /// Usuwa lokalizację
  Future<void> _deleteLocation(SavedLocation location) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Usuń lokalizację'),
        content: Text('Czy na pewno chcesz usunąć lokalizację "${location.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Usuń'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _settingsService.removeSavedLocation(location.id);
      await _loadSettings();
      await NotificationService.updateNotifications();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Usunięto lokalizację: ${location.name}'),
            backgroundColor: AppTheme.primaryBlue,
          ),
        );
      }
    }
  }
}
