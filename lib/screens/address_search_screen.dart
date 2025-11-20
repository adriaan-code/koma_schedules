import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../models/address.dart';
import '../models/api_models.dart';
import '../services/api_service.dart';
import '../services/location_history_service.dart';
import '../widgets/koma_header.dart';

class AddressSearchScreen extends StatefulWidget {
  const AddressSearchScreen({
    super.key,
    this.onLanguageChanged,
    this.returnAddress = false,
  });
  final void Function(String)? onLanguageChanged;
  final bool returnAddress; // Jeśli true, zwraca Address zamiast nawigować

  @override
  State<AddressSearchScreen> createState() => _AddressSearchScreenState();
}

class _AddressSearchScreenState extends State<AddressSearchScreen> {
  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  final ApiService _apiService = ApiService();
  // Quick text search temporarily removed (will revisit in future)
  final FocusNode _sectorFocusNode = FocusNode();
  final FocusNode _prefiksFocusNode = FocusNode();
  final FocusNode _localityFocusNode = FocusNode();
  final FocusNode _streetFocusNode = FocusNode();
  final FocusNode _propertyFocusNode = FocusNode();

  Map<String, Map<String, List<Address>>> _sectors = {};
  String? _selectedSector;
  String? _selectedPrefiks;
  Address? _selectedLocation;
  List<String> _streets = [];
  String? _selectedStreet;
  List<ApiProperty> _properties = [];
  ApiProperty? _selectedProperty;
  bool _isLoading = true;
  String? _errorMessage;
  List<Address> _recentLocations = [];
  List<Address> _favoriteLocations = [];
  bool _isLoadingStreets = false;
  bool _isLoadingProperties = false;

  @override
  void dispose() {
    // quick search controller removed
    _sectorFocusNode.dispose();
    _prefiksFocusNode.dispose();
    _localityFocusNode.dispose();
    _streetFocusNode.dispose();
    _propertyFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadSectors();
    _loadRecentLocations();
    _loadFavoriteLocations();
    // quick search listener removed
  }

  /// Ładuje ostatnie lokalizacje z pamięci
  Future<void> _loadRecentLocations() async {
    try {
      final locations = await LocationHistoryService.getRecentLocations();
      if (!mounted) return;
      setState(() {
        _recentLocations = locations;
      });
    } catch (e) {
      debugPrint('Błąd ładowania ostatnich lokalizacji: $e');
    }
  }

  /// Ładuje ulubione lokalizacje z pamięci
  Future<void> _loadFavoriteLocations() async {
    try {
      final favorites = await LocationHistoryService.getFavorites();
      if (!mounted) return;
      setState(() {
        _favoriteLocations = favorites;
      });
    } catch (e) {
      debugPrint('Błąd ładowania ulubionych lokalizacji: $e');
    }
  }


  Future<void> _loadSectors() async {
    if (kDebugMode) {
      debugPrint('_loadSectors() rozpoczęte');
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    if (kDebugMode) {
      debugPrint('_isLoading ustawione na true');
    }

    try {
      if (kDebugMode) {
        debugPrint('Wywołuję _apiService.getSectors()');
      }
      final sectorsResponse = await _apiService.getSectors();
      if (kDebugMode) {
        debugPrint('Otrzymano odpowiedź z API');
      }

      final Map<String, Map<String, List<Address>>> sectors = {};

      sectorsResponse.sectors.forEach((sectorName, gminy) {
        final Map<String, List<Address>> gminyMap = {};
        gminy.forEach((gminaName, locations) {
          gminyMap[gminaName] = locations
              .map(
                (location) => Address(
                  street: location.miejscowosc,
                  city: location.gmina,
                  postalCode: '',
                ),
              )
              .toList();
        });
        sectors[sectorName] = gminyMap;
      });

      if (kDebugMode) {
        debugPrint('Przed setState - _sectors.length: ${sectors.length}');
      }
      if (!mounted) return;
      setState(() {
        _sectors = sectors;
        _isLoading = false;
      });
      if (kDebugMode) {
        debugPrint('Po setState - _isLoading: $_isLoading');

        // Debug: sprawdź czy dane zostały załadowane
        debugPrint('Załadowano ${_sectors.length} sektorów:');
        _sectors.forEach((sector, gminy) {
          debugPrint('- $sector: ${gminy.length} gmin');
          gminy.forEach((gmina, locations) {
            debugPrint('  - $gmina: ${locations.length} miejscowości');
          });
        });

        // Debug: sprawdź czy lista sektorów nie jest pusta
        debugPrint('Lista sektorów do wyboru: ${_sectors.keys.toList()}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Błąd ładowania sektorów: $e');
      }
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadStreets(
    String prefix,
    String gmina,
    String miejscowosc,
  ) async {
    if (_isLoadingStreets) return; // Zapobiegaj wielokrotnym wywołaniom

    setState(() {
      _isLoadingStreets = true;
    });

    try {
      if (kDebugMode) {
        debugPrint('Ładowanie ulic dla: $prefix/$gmina/$miejscowosc');
      }
      final streets = await _apiService.getStreets(prefix, gmina, miejscowosc);

      if (mounted) {
        setState(() {
          _streets = streets.map((street) => street.ulica).toList();
          _selectedStreet = null;
          _selectedProperty = null;
          _properties = [];
          _isLoadingStreets = false;
        });

        if (kDebugMode) {
          debugPrint(
            'Załadowano ${_streets.length} ulic: ${_streets.take(5).join(', ')}...',
          );
        }

        // Jeśli nie ma ulic lub jest tylko jedna pusta ulica, automatycznie załaduj posesje dla miejscowości
        if (_streets.isEmpty ||
            (_streets.length == 1 && _streets.first.isEmpty)) {
          if (kDebugMode) {
            debugPrint(
              'Brak ulic lub jedna pusta ulica - ładowanie posesji bezpośrednio dla miejscowości',
            );
          }
          await _loadProperties(prefix, gmina, miejscowosc, '');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Błąd ładowania ulic: $e');
      }
      if (mounted) {
        setState(() {
          _streets = [];
          _selectedStreet = null;
          _selectedProperty = null;
          _properties = [];
          _isLoadingStreets = false;
        });
      }
    }
  }

  Future<void> _loadProperties(
    String prefix,
    String gmina,
    String miejscowosc,
    String ulica,
  ) async {
    if (_isLoadingProperties) return; // Zapobiegaj wielokrotnym wywołaniom

    setState(() {
      _isLoadingProperties = true;
    });

    try {
      if (kDebugMode) {
        debugPrint('Ładowanie posesji dla: $prefix/$gmina/$miejscowosc/$ulica');
      }
      final properties = await _apiService.getProperties(
        prefix,
        gmina,
        miejscowosc,
        ulica,
      );

      if (mounted) {
        setState(() {
          _properties = properties;
          _selectedProperty = null;
          _isLoadingProperties = false;
        });

        if (kDebugMode) {
          debugPrint(
            'Załadowano ${_properties.length} posesji: ${_properties.map((p) => p.fullNumber).join(', ')}',
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Błąd ładowania posesji: $e');
      }
      if (mounted) {
        setState(() {
          _properties = [];
          _selectedProperty = null;
          _isLoadingProperties = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      debugPrint(
        'build() wywołane - _isLoading: $_isLoading, _sectors.length: ${_sectors.length}',
      );
    }
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            // Header z logo KOMA
            KomaHeader.logoOnly(),

            // Tytuł "WYSZUKAJ ADRES"
            const Center(
              child: Column(
                children: [
                  Text(
                    'WYSZUKAJ',
                    style: TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                      color: AppTheme.textBlack,
                    ),
                  ),
                  Text(
                    'ADRES',
                    style: TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.normal,
                      color: AppTheme.textBlack,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Lista rozwijana sektorów
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value:
                            (_selectedSector != null &&
                                _sectors.containsKey(_selectedSector))
                            ? _selectedSector
                            : null,
                        hint: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            _isLoading
                                ? AppLocalizations.of(context)!.loadingSectors
                                : AppLocalizations.of(context)!.selectSector,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        isExpanded: true,
                        onTap: () {
                          if (kDebugMode) {
                            debugPrint('DropdownButton tapped');
                            debugPrint('_selectedSector: $_selectedSector');
                            debugPrint(
                              '_sectors.keys: ${_sectors.keys.toList()}',
                            );
                            debugPrint('_isLoading: $_isLoading');
                          }
                        },
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.textPrimary,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.keyboard_arrow_down,
                                color: AppTheme.textPrimary,
                              ),
                        items: _sectors.keys.map((String sector) {
                          return DropdownMenuItem<String>(
                            value: sector,
                            child: Text(
                              sector,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: _isLoading
                            ? null
                            : (String? newValue) {
                                if (kDebugMode) {
                                  debugPrint(
                                    'onChanged wywołany - newValue: $newValue',
                                  );
                                  debugPrint('_isLoading: $_isLoading');
                                  debugPrint(
                                    '_sectors.keys: ${_sectors.keys.toList()}',
                                  );
                                }
                                setState(() {
                                  _selectedSector = newValue;
                                  _selectedPrefiks = null;
                                  _selectedLocation = null;
                                  _selectedStreet = null;
                                  _selectedProperty = null;
                                  _streets = [];
                                  _properties = [];
                                });
                                if (kDebugMode) {
                                  debugPrint(
                                    'Po setState - _selectedSector: $_selectedSector',
                                  );
                                }
                              },
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      height: 2,
                      width: double.infinity,
                      color: AppTheme.textPrimary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Lista rozwijana prefiksów (jeśli sektor wybrany)
            if (_selectedSector != null &&
                _sectors[_selectedSector] != null) ...[
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedPrefiks,
                          hint: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              AppLocalizations.of(context)!.selectPrefix,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppTheme.textPrimary,
                          ),
                          items: _sectors[_selectedSector]!.keys.map((
                            String prefiks,
                          ) {
                            return DropdownMenuItem<String>(
                              value: prefiks,
                              child: Text(
                                prefiks,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (kDebugMode) {
                              debugPrint('Wybrano prefiks: $newValue');
                            }
                            setState(() {
                              _selectedPrefiks = newValue;
                              _selectedLocation = null;
                              _selectedStreet = null;
                              _selectedProperty = null;
                              _streets = [];
                              _properties = [];
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        height: 2,
                        width: double.infinity,
                        color: AppTheme.textPrimary,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Lista rozwijana miejscowości (jeśli prefiks wybrany)
            if (_selectedPrefiks != null &&
                _sectors[_selectedSector]?[_selectedPrefiks] != null) ...[
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton<Address>(
                          value: _selectedLocation,
                          hint: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              AppLocalizations.of(context)!.selectLocality,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppTheme.textPrimary,
                          ),
                          items: _sectors[_selectedSector]![_selectedPrefiks]!
                              .map((Address location) {
                                return DropdownMenuItem<Address>(
                                  value: location,
                                  child: Text(
                                    location.street,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                );
                              })
                              .toList(),
                          onChanged: (Address? newValue) {
                            if (kDebugMode) {
                              debugPrint(
                                'Wybrano miejscowość: ${newValue?.toString()}',
                              );
                            }
                            setState(() {
                              _selectedLocation = newValue;
                              _selectedStreet = null;
                              _selectedProperty = null;
                              _streets = [];
                              _properties = [];
                            });

                            // Załaduj ulice dla wybranej miejscowości
                            if (newValue != null) {
                              _loadStreets(
                                _selectedPrefiks!,
                                newValue.city,
                                newValue.street,
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        height: 2,
                        width: double.infinity,
                        color: AppTheme.textPrimary,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Lista rozwijana ulic (jeśli miejscowość wybrana i są ulice, ale nie tylko jedna pusta)
            if (_selectedLocation != null &&
                _streets.isNotEmpty &&
                !(_streets.length == 1 && _streets.first.isEmpty)) ...[
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedStreet,
                          hint: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              AppLocalizations.of(context)!.selectStreet,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppTheme.textPrimary,
                          ),
                          items: _streets.map((String street) {
                            return DropdownMenuItem<String>(
                              value: street,
                              child: Text(
                                street,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (kDebugMode) {
                              debugPrint('Wybrano ulicę: $newValue');
                            }
                            setState(() {
                              _selectedStreet = newValue;
                              _selectedProperty = null;
                              _properties = [];
                            });

                            // Załaduj posesje dla wybranej ulicy
                            if (newValue != null &&
                                _selectedLocation != null &&
                                _selectedPrefiks != null) {
                              _loadProperties(
                                _selectedPrefiks!,
                                _selectedLocation!.city,
                                _selectedLocation!.street,
                                newValue,
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        height: 2,
                        width: double.infinity,
                        color: AppTheme.textPrimary,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Lista rozwijana posesji (jeśli ulica wybrana lub nie ma ulic lub tylko jedna pusta ulica)
            if (_selectedStreet != null ||
                (_selectedLocation != null &&
                    (_streets.isEmpty ||
                        (_streets.length == 1 && _streets.first.isEmpty)) &&
                    _properties.isNotEmpty)) ...[
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton<ApiProperty>(
                          value: _selectedProperty,
                          hint: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              _properties.isEmpty
                                  ? AppLocalizations.of(context)!.noProperties
                                  : AppLocalizations.of(
                                      context,
                                    )!.selectProperty,
                              style: TextStyle(
                                color: _properties.isEmpty
                                    ? AppTheme.errorRed
                                    : AppTheme.textPrimary,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppTheme.textPrimary,
                          ),
                          items: _properties.map((ApiProperty property) {
                            return DropdownMenuItem<ApiProperty>(
                              value: property,
                              child: Text(
                                property.fullNumber,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (ApiProperty? newValue) {
                            if (kDebugMode) {
                              debugPrint(
                                'Wybrano posesję: ${newValue?.fullNumber}',
                              );
                            }
                            setState(() {
                              _selectedProperty = newValue;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        height: 2,
                        width: double.infinity,
                        color: AppTheme.textPrimary,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Sekcja z zawartością
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
            ),
            SizedBox(height: 16),
            Text(
              'Ładowanie sektorów...',
              style: TextStyle(
                fontSize: AppTheme.fontSizeMedium,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppTheme.grey400),
            const SizedBox(height: AppTheme.spacingMedium),
            Text(
              AppLocalizations.of(context)!.loadingSectorsError,
              style: const TextStyle(
                fontSize: AppTheme.fontSizeLarge,
                fontWeight: FontWeight.bold,
                color: AppTheme.grey600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSmall),
            Padding(
              padding: AppTheme.paddingHorizontal,
              child: Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: AppTheme.fontSizeSmall, color: AppTheme.grey500),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadSectors,
              child: Text(AppLocalizations.of(context)!.tryAgain),
            ),
          ],
        ),
      );
    }

    // Jeśli wybrano posesję, pokaż przycisk do harmonogramu
    if (_selectedProperty != null) {
      return Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              // Wybrany adres z ikonką w tle
              Container(
                padding: AppTheme.paddingHorizontal,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Ikonka w tle z opacity 50%
                    Icon(
                      Icons.location_on,
                      color: AppTheme.textPrimary.withValues(alpha: 0.2),
                      size: 120,
                    ),
                    // Tekst adresu na wierzchu
                    Text(
                      _selectedStreet != null
                          ? '${_selectedLocation!.street}, $_selectedStreet ${_selectedProperty!.fullNumber}'
                          : '${_selectedLocation!.street}, ${_selectedProperty!.fullNumber}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              // Czarny pasek
              const SizedBox(height: 24),
              // Przycisk
              SizedBox(
                width: double.infinity,
                child: Semantics(
                  button: true,
                  label: 'Pokaż harmonogram odbioru odpadów',
                  hint: 'Dotknij aby przejść do harmonogramu',
                  child: ElevatedButton(
                    onPressed: () async {
                      // Stwórz pełny adres z posesją
                      final fullAddress = Address(
                        street: _selectedStreet != null
                            ? '$_selectedStreet ${_selectedProperty!.fullNumber}'
                            : _selectedProperty!.fullNumber,
                        city: _selectedLocation!.city,
                        postalCode: _selectedLocation!.postalCode,
                        prefix: _selectedPrefiks,
                        propertyNumber: _selectedProperty!.numer_posesji,
                      );

                      // Zapisz jako ostatnią lokalizację
                      await LocationHistoryService.saveRecentLocation(
                        fullAddress,
                      );

                      // Sprawdź czy widget jest jeszcze zamontowany
                      if (!mounted) return;

                      // Jeśli returnAddress jest true, zwróć adres zamiast nawigować
                      if (widget.returnAddress) {
                        Navigator.of(context).pop(fullAddress);
                      } else {
                        // Przejdź do ekranu harmonogramu
                        Navigator.pushNamed(
                          context,
                          '/waste-schedule',
                          arguments: fullAddress,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.textPrimary,
                      foregroundColor: AppTheme.backgroundWhite,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.showSchedule,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Pokaż ulubione i ostatnie lokalizacje jeśli są dostępne, w przeciwnym razie instrukcję
    if (_favoriteLocations.isNotEmpty || _recentLocations.isNotEmpty) {
      return _buildLocationsSection();
    }

    // Domyślnie pokaż instrukcję
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_city, size: 64, color: AppTheme.grey400),
          const SizedBox(height: AppTheme.spacingMedium),
          Text(
            AppLocalizations.of(context)!.selectSectorAndLocality,
            style: const TextStyle(
              fontSize: AppTheme.fontSizeLarge,
              fontWeight: FontWeight.bold,
              color: AppTheme.grey600,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSmall),
        ],
      ),
    );
  }

  /// Buduje sekcję z ostatnimi lokalizacjami
  Widget _buildLocationsSection() {
    return Padding(
      padding: AppTheme.paddingAll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sekcja ulubionych
          if (_favoriteLocations.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.star,
                    size: 20,
                    color: Color.fromRGBO(0, 86, 157, 1),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.favoriteLocations,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(0, 86, 157, 1),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            ...(_favoriteLocations.map(
              (location) => _buildLocationItem(location, isFavorite: true),
            )),
          ],

          // Sekcja ostatnich lokalizacji
          if (_recentLocations.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.history, size: 20, color: AppTheme.grey600),
                  const SizedBox(width: AppTheme.spacingSmall),
                  Text(
                    AppLocalizations.of(context)!.recentLocations,
                    style: const TextStyle(
                      fontSize: AppTheme.fontSizeMedium,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.grey700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            ...(_recentLocations.map(
              (location) => _buildLocationItem(location, isFavorite: false),
            )),
            const SizedBox(height: AppTheme.spacingMedium),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  /// Buduje element lokalizacji (ulubionej lub ostatniej)
  Widget _buildLocationItem(Address location, {required bool isFavorite}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
        color: AppTheme.backgroundWhite,
        border: Border(
          left: BorderSide(color: AppTheme.textBlack, width: 3),
          right: BorderSide(color: AppTheme.textBlack, width: 3),
        ),
      ),
      child: InkWell(
        onTap: () async {
          // Zapisz jako ostatnią lokalizację (przenieś na górę listy)
          await LocationHistoryService.saveRecentLocation(location);

          // Sprawdź czy widget jest jeszcze zamontowany
          if (!mounted) return;

          // Jeśli returnAddress jest true, zwróć adres zamiast nawigować
          if (widget.returnAddress) {
            Navigator.of(context).pop(location);
          } else {
            // Przejdź do harmonogramu
            Navigator.pushNamed(context, '/waste-schedule', arguments: location);
          }
        },
        onLongPress: () => _toggleFavorite(location, isFavorite),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
          child: Row(
            children: [
              // Ikona lokalizacji
              const Icon(
                Icons.location_on,
                color: Color.fromRGBO(0, 86, 157, 1),
                size: 36,
              ),
              const SizedBox(width: 16),
              // Adres
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.street,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textBlack,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXSmall),
                    Text(
                      location.city,
                      style: const TextStyle(
                        fontSize: AppTheme.fontSizeSmall,
                        color: AppTheme.grey600,
                      ),
                    ),
                  ],
                ),
              ),
              // Złota gwiazdka do zarządzania ulubionymi
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: const Color.fromRGBO(0, 86, 157, 1),
                  size: 28,
                ),
                onPressed: () => _toggleFavorite(location, isFavorite),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Dodaje/usuwa lokalizację z ulubionych z confirmation dialog
  Future<void> _toggleFavorite(Address location, bool isFavorite) async {
    if (isFavorite) {
      // Confirmation dialog dla usuwania z ulubionych
      final confirm = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.removedFromFavorites),
            content: Text(
              'Czy na pewno chcesz usunąć ${location.fullAddress} z ulubionych?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(AppLocalizations.of(context)!.delete),
              ),
            ],
          );
        },
      );

      if (confirm ?? false) {
        await LocationHistoryService.removeFromFavorites(location);
        await _loadFavoriteLocations();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${AppLocalizations.of(context)!.removedFromFavorites}: ${location.fullAddress}',
              ),
              backgroundColor: const Color.fromRGBO(0, 86, 157, 1),
            ),
          );
        }
      }
    } else {
      // Dodaj do ulubionych bez confirmation
      await LocationHistoryService.addToFavorites(location);
      await _loadFavoriteLocations();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context)!.addedToFavorites}: ${location.fullAddress}',
            ),
            backgroundColor: const Color.fromRGBO(0, 86, 157, 1),
          ),
        );
      }
    }
  }
}
