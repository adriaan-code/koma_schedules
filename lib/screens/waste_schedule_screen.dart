import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../models/address.dart';
import '../models/waste_collection.dart';
import '../services/api_service.dart';
import '../widgets/koma_header.dart';
import '../utils/date_utils.dart';
import '../utils/waste_type_utils.dart';

class WasteScheduleScreen extends StatefulWidget {
  const WasteScheduleScreen({
    super.key,
    required this.selectedAddress,
    this.onLanguageChanged,
  });
  final Address selectedAddress;
  final void Function(String)? onLanguageChanged;

  @override
  State<WasteScheduleScreen> createState() => _WasteScheduleScreenState();
}

class _WasteScheduleScreenState extends State<WasteScheduleScreen> {
  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  final ApiService _apiService = ApiService();
  List<WasteCollection> _schedule = [];
  bool _isLoading = true;
  String? _errorMessage;
  late Address _currentAddress;
  Map<String, List<WasteCollection>>? _cachedGroupedSchedule;

  @override
  void initState() {
    super.initState();
    _currentAddress = widget.selectedAddress;
    _loadSchedule();
  }

  

  Future<void> _loadSchedule() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Debug logging dla adresu
      if (kDebugMode) {
        debugPrint('=== ADRES DEBUG ===');
        debugPrint('Prefix: "${_currentAddress.prefix}"');
        debugPrint('Property Number: "${_currentAddress.propertyNumber}"');
        debugPrint('Full Address: "${_currentAddress.fullAddress}"');
        debugPrint('==================');
      }

      final schedule = await _apiService.getWasteSchedule(
        _currentAddress.prefix ?? '',
        _currentAddress.propertyNumber ?? '',
      );

      // Filtruj harmonogram - tylko od aktualnego miesiąca do końca roku
      final filteredSchedule = _filterScheduleForCurrentYear(schedule);

      // Debug logging
      if (kDebugMode) {
        debugPrint('=== HARMONOGRAM DEBUG ===');
        debugPrint('Oryginalny harmonogram: ${schedule.length} elementów');
        debugPrint('Przefiltrowany harmonogram: ${filteredSchedule.length} elementów');
        debugPrint('Aktualny miesiąc: ${DateTime.now().month}');
        if (schedule.isNotEmpty) {
          debugPrint('Pierwszy element: ${schedule.first.month} ${schedule.first.day}');
        }
        if (filteredSchedule.isNotEmpty) {
          debugPrint('Pierwszy przefiltrowany: ${filteredSchedule.first.month} ${filteredSchedule.first.day}');
        }
        debugPrint('========================');
      }

      if (mounted) {
        setState(() {
          _schedule = filteredSchedule;
          _isLoading = false;
          _cachedGroupedSchedule = null; // Wyczyść cache
        });

        // Feedback dla użytkownika
        if (filteredSchedule.isEmpty) {
          if (kDebugMode) {
            debugPrint('HARMONOGRAM PUSTY - wyświetlam SnackBar');
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.noData),
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          if (kDebugMode) {
            debugPrint('HARMONOGRAM OK - wyświetlam ${filteredSchedule.length} elementów');
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
          _schedule = []; // Pusta lista zamiast przykładowych danych
          _cachedGroupedSchedule = null; // Wyczyść cache
        });
      }
    }
  }

  /// Filtruje harmonogram - pokazuje tylko od aktualnego miesiąca do końca roku
  List<WasteCollection> _filterScheduleForCurrentYear(
    List<WasteCollection> schedule,
  ) {
    final now = DateTime.now();
    final currentMonth = now.month;

    // Lista kluczy miesięcy w kolejności (używamy kluczy lokalizacji)
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

    return schedule.where((collection) {
      // Znajdź numer miesiąca dla tego elementu harmonogramu
      final monthIndex = months.indexOf(collection.month.toLowerCase());
      if (monthIndex == -1) return false; // Nieznany miesiąc

      final collectionMonth = monthIndex + 1; // +1 bo miesiące są 1-12

      // Sprawdź czy to przyszły miesiąc lub aktualny miesiąc (ale tylko przyszłe dni)
      if (collectionMonth > currentMonth) {
        return true; // Przyszłe miesiące w tym roku
      } else if (collectionMonth == currentMonth) {
        // W aktualnym miesiącu - tylko przyszłe dni
        return collection.day >= now.day;
      } else {
        // Przeszłe miesiące - ale jeśli jesteśmy w grudniu, pokaż wszystkie miesiące
        // bo harmonogram może być na następny rok
        if (currentMonth == 12) {
          return true; // W grudniu pokazuj wszystkie miesiące
        }
        return false; // Przeszłe miesiące
      }
    }).toList();
  }

  void _navigateToAddressSelection() async {
    // Przejdź do ekranu wyboru adresu i poczekaj na wynik
    final result = await Navigator.pushNamed(context, '/address-search');

    // Jeśli użytkownik wybrał nowy adres, zmień adres i odśwież harmonogram
    if (result is Address && result != _currentAddress) {
      setState(() {
        _currentAddress = result;
      });

      // Feedback dla użytkownika
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context)!.addressChangedTo}: ${result.fullAddress}'),
            duration: const Duration(seconds: 2),
            backgroundColor: AppTheme.primaryBlue,
          ),
        );
      }

      _loadSchedule();
    }
  }

  // Grupuje harmonogram według miesięcy z cache'owaniem
  Map<String, List<WasteCollection>> _groupScheduleByMonth() {
    if (_cachedGroupedSchedule != null) {
      return _cachedGroupedSchedule!;
    }

    final Map<String, List<WasteCollection>> grouped = {};
    for (final collection in _schedule) {
      if (!grouped.containsKey(collection.month)) {
        grouped[collection.month] = [];
      }
      grouped[collection.month]!.add(collection);
    }

    _cachedGroupedSchedule = grouped;
    return grouped;
  }

  Widget _buildScheduleContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppTheme.grey400),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.error,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.grey600,
              ),
            ),
            const SizedBox(height: 8),
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
              onPressed: _loadSchedule,
              child: Text(AppLocalizations.of(context)!.tryAgain),
            ),
          ],
        ),
      );
    }

    // Sprawdź czy harmonogram jest pusty
    if (_schedule.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 64,
              color: AppTheme.grey400,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noData,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.grey600,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: AppTheme.paddingHorizontal,
              child: Text(
                'Dla tego adresu nie znaleziono harmonogramu odbioru odpadów.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: AppTheme.fontSizeSmall, color: AppTheme.grey500),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadSchedule,
              child: Text(AppLocalizations.of(context)!.tryAgain),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadSchedule,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _buildScheduleList(),
      ),
    );
  }

  Widget _buildScheduleList() {
    final groupedSchedule = _groupScheduleByMonth();
    final List<Widget> children = [];

    // Lista kluczy miesięcy w kolejności chronologicznej
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

    // Sortuj miesiące według kolejności chronologicznej
    final sortedMonths = months.where((month) => groupedSchedule.containsKey(month)).toList();

    for (final month in sortedMonths) {
      final collections = groupedSchedule[month]!;
      
      // Sortuj kolekcje według dnia
      collections.sort((a, b) => a.day.compareTo(b.day));

      // Nagłówek miesiąca
      children.add(
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            getLocalizedMonthName(AppLocalizations.of(context)!, month),
            style: const TextStyle(
                fontSize: 18,
              color: AppTheme.grey500,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );

      // Elementy harmonogramu
      for (int i = 0; i < collections.length; i++) {
        final collection = collections[i];

        // Sprawdź czy następne elementy mają tę samą datę
        if (i + 2 < collections.length &&
            collections[i + 1].day == collection.day &&
            collections[i + 1].month == collection.month &&
            collections[i + 2].day == collection.day &&
            collections[i + 2].month == collection.month) {
          // Trzy elementy w tym samym dniu
          children.add(_buildTripleScheduleItem(collection, collections[i + 1], collections[i + 2]));
          i += 2; // Pomiń następne dwa elementy
        } else if (i + 1 < collections.length &&
            collections[i + 1].day == collection.day &&
            collections[i + 1].month == collection.month) {
          // Dwa elementy w tym samym dniu
          children.add(_buildSplitScheduleItem(collection, collections[i + 1]));
          i++; // Pomiń następny element
        } else {
          // Pojedynczy element
          children.add(_buildScheduleItem(collection));
        }
      }
    }

    return Column(children: children);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            // Nagłówek z adresem i logo
            KomaHeader.withAddress(
              address: _currentAddress.fullAddress,
              onAddressTap: _navigateToAddressSelection,
            ),
            const SizedBox(height: 16),

            // Tytuł harmonogramu
            Padding(
              padding: AppTheme.paddingHorizontal,
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.wasteSchedule,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textBlack,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Lista harmonogramu
            Expanded(child: _buildScheduleContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(WasteCollection collection) {
    return Semantics(
      button: true,
      label:
          'Odbiór ${WasteTypeUtils.getLocalizedWasteTypeName(AppLocalizations.of(context)!, collection.wasteType)}, ${collection.day} ${getLocalizedMonthName(AppLocalizations.of(context)!, collection.month)}, ${getLocalizedDayName(AppLocalizations.of(context)!, collection.dayOfWeek)}',
      hint: 'Dotknij aby zobaczyć szczegóły',
      child: _ScheduleItemWidget(
        collection: collection,
        onTap: () {
          Navigator.pushNamed(
            context,
            '/waste-details',
            arguments: [collection],
          );
        },
      ),
    );
  }

  Widget _buildSplitScheduleItem(
    WasteCollection first,
    WasteCollection second,
  ) {
    return Semantics(
      button: true,
      label:
          'Dwa odbiory: ${WasteTypeUtils.getLocalizedWasteTypeName(AppLocalizations.of(context)!, first.wasteType)} i ${WasteTypeUtils.getLocalizedWasteTypeName(AppLocalizations.of(context)!, second.wasteType)}, ${first.day} ${getLocalizedMonthName(AppLocalizations.of(context)!, first.month)}, ${getLocalizedDayName(AppLocalizations.of(context)!, first.dayOfWeek)}',
      hint: 'Dotknij aby zobaczyć szczegóły',
      child: _SplitScheduleItemWidget(
        first: first,
        second: second,
        onTap: () {
          Navigator.pushNamed(
            context,
            '/waste-details',
            arguments: [first, second],
          );
        },
      ),
    );
  }

  Widget _buildTripleScheduleItem(
    WasteCollection first,
    WasteCollection second,
    WasteCollection third,
  ) {
    return Semantics(
      button: true,
      label:
          'Trzy odbiory: ${WasteTypeUtils.getLocalizedWasteTypeName(AppLocalizations.of(context)!, first.wasteType)}, ${WasteTypeUtils.getLocalizedWasteTypeName(AppLocalizations.of(context)!, second.wasteType)} i ${WasteTypeUtils.getLocalizedWasteTypeName(AppLocalizations.of(context)!, third.wasteType)}, ${first.day} ${getLocalizedMonthName(AppLocalizations.of(context)!, first.month)}, ${getLocalizedDayName(AppLocalizations.of(context)!, first.dayOfWeek)}',
      hint: 'Dotknij aby zobaczyć szczegóły',
      child: _TripleScheduleItemWidget(
        first: first,
        second: second,
        third: third,
        onTap: () {
          Navigator.pushNamed(
            context,
            '/waste-details',
            arguments: [first, second, third],
          );
        },
      ),
    );
  }
}

// Stałe dla layoutu harmonogramu
class _ScheduleConstants {
  // Wymiary kontenerów
  static const double dateContainerWidth = 100.0;
  static const double singleItemHeight = 60.0;
  static const double splitItemHeight = 120.0;
  static const double tripleItemHeight = 180.0;

  // Szerokości pasków
  static const double barWidth = 4.0;

  // Paddingi
  static const double horizontalPadding = 14.0;
  static const double itemBottomMargin = 20.0;

  // Rozmiary fontów
  static const double dateFontSize = 36.0;
  static const double dayOfWeekFontSize = 8.0;
  static const double wasteTypeFontSize = 20.0;

  // Wysokości linii tekstu
  static const double dateLineHeight = 0.8;
  static const double wasteTypeLineHeight = 1.0;
}

// Zoptymalizowany widget dla pojedynczego elementu harmonogramu
class _ScheduleItemWidget extends StatelessWidget {
  const _ScheduleItemWidget({required this.collection, required this.onTap});
  final WasteCollection collection;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(
          bottom: _ScheduleConstants.itemBottomMargin,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kolumna z datą z paskami po obu stronach
            SizedBox(
              width: _ScheduleConstants.dateContainerWidth,
              child: Row(
                children: [
                  // Lewy pasek
                  Container(
                    width: _ScheduleConstants.barWidth,
                    height: _ScheduleConstants.singleItemHeight,
                    decoration: BoxDecoration(
                      color: collection.wasteType.color,
                    ),
                  ),
                  const SizedBox(width: _ScheduleConstants.horizontalPadding),
                  // Data i dzień tygodnia
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          collection.day.toString(),
                          style: const TextStyle(
                            fontSize: _ScheduleConstants.dateFontSize,
                            height: _ScheduleConstants.dateLineHeight,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.textBlack,
                          ),
                        ),
                        Text(
                          getLocalizedDayName(
                            AppLocalizations.of(context)!,
                            collection.dayOfWeek,
                          ),
                          style: const TextStyle(
                            fontSize: _ScheduleConstants.dayOfWeekFontSize,
                            color: AppTheme.grey400,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: _ScheduleConstants.horizontalPadding),
                  // Prawy pasek
                  Container(
                    width: _ScheduleConstants.barWidth,
                    height: _ScheduleConstants.singleItemHeight,
                    decoration: BoxDecoration(
                      color: collection.wasteType.color,
                    ),
                  ),
                ],
              ),
            ),

            // Nazwa typu odpadu wyrównana do prawej z paskiem po prawej stronie
            Expanded(
              child: SizedBox(
                height: _ScheduleConstants.singleItemHeight,
                child: Row(
                  children: [
                    // Tekst odpadu
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          WasteTypeUtils.getLocalizedWasteTypeName(
                            AppLocalizations.of(context)!,
                            collection.wasteType,
                          ).toUpperCase(),
                          style: const TextStyle(
                            fontSize: _ScheduleConstants.wasteTypeFontSize,
                            color: AppTheme.textBlack,
                            height: _ScheduleConstants.wasteTypeLineHeight,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    const SizedBox(width: _ScheduleConstants.horizontalPadding),
                    // Prawy pasek po prawej stronie tekstu
                    Container(
                      width: _ScheduleConstants.barWidth,
                      height: _ScheduleConstants.singleItemHeight,
                      decoration: BoxDecoration(
                        color: collection.wasteType.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Zoptymalizowany widget dla podzielonego elementu harmonogramu
class _SplitScheduleItemWidget extends StatelessWidget {
  const _SplitScheduleItemWidget({
    required this.first,
    required this.second,
    required this.onTap,
  });
  final WasteCollection first;
  final WasteCollection second;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(
          bottom: _ScheduleConstants.itemBottomMargin,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kolumna z datą z podzielonymi paskami po obu stronach
            SizedBox(
              width: _ScheduleConstants.dateContainerWidth,
              child: Row(
                children: [
                  // Lewy pasek (podzielony)
                  SizedBox(
                    width: _ScheduleConstants.barWidth,
                    height: _ScheduleConstants.splitItemHeight,
                    child: Column(
                      children: [
                        // Górna część - różowy (GABARYTY)
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: first.wasteType.color,
                            ),
                          ),
                        ),
                        // Dolna część - niebieski (PAPIER)
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: second.wasteType.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: _ScheduleConstants.horizontalPadding),
                  // Data i dzień tygodnia
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          first.day.toString(),
                          style: const TextStyle(
                            fontSize: _ScheduleConstants.dateFontSize,
                            height: _ScheduleConstants.dateLineHeight,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.textBlack,
                          ),
                        ),
                        Text(
                          getLocalizedDayName(
                            AppLocalizations.of(context)!,
                            first.dayOfWeek,
                          ),
                          style: const TextStyle(
                            fontSize: _ScheduleConstants.dayOfWeekFontSize,
                            color: AppTheme.grey400,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: _ScheduleConstants.horizontalPadding),
                  // Prawy pasek (podzielony)
                  SizedBox(
                    width: _ScheduleConstants.barWidth,
                    height: _ScheduleConstants.splitItemHeight,
                    child: Column(
                      children: [
                        // Górna część - różowy (GABARYTY)
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: first.wasteType.color,
                            ),
                          ),
                        ),
                        // Dolna część - niebieski (PAPIER)
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: second.wasteType.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Nazwy typów odpadów wyrównane do prawej z podzielonymi paskami po prawej stronie
            Expanded(
              child: SizedBox(
                height: _ScheduleConstants.splitItemHeight,
                child: Row(
                  children: [
                    // Tekst odpadów
                    Expanded(
                      child: Column(
                        children: [
                          // GABARYTY - górna połowa
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                WasteTypeUtils.getLocalizedWasteTypeName(
                                  AppLocalizations.of(context)!,
                                  first.wasteType,
                                ).toUpperCase(),
                                style: const TextStyle(
                                  fontSize:
                                      _ScheduleConstants.wasteTypeFontSize,
                                  color: AppTheme.textBlack,
                                  height:
                                      _ScheduleConstants.wasteTypeLineHeight,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          // PAPIER - dolna połowa
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                WasteTypeUtils.getLocalizedWasteTypeName(
                                  AppLocalizations.of(context)!,
                                  second.wasteType,
                                ).toUpperCase(),
                                style: const TextStyle(
                                  fontSize:
                                      _ScheduleConstants.wasteTypeFontSize,
                                  color: AppTheme.textBlack,
                                  height:
                                      _ScheduleConstants.wasteTypeLineHeight,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: _ScheduleConstants.horizontalPadding),
                    // Podzielone paski po prawej stronie tekstu
                    SizedBox(
                      width: _ScheduleConstants.barWidth,
                      height: _ScheduleConstants.splitItemHeight,
                      child: Column(
                        children: [
                          // Górna część - różowy (GABARYTY)
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: first.wasteType.color,
                              ),
                            ),
                          ),
                          // Dolna część - niebieski (PAPIER)
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: second.wasteType.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Zoptymalizowany widget dla potrójnego elementu harmonogramu
class _TripleScheduleItemWidget extends StatelessWidget {
  const _TripleScheduleItemWidget({
    required this.first,
    required this.second,
    required this.third,
    required this.onTap,
  });
  final WasteCollection first;
  final WasteCollection second;
  final WasteCollection third;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(
          bottom: _ScheduleConstants.itemBottomMargin,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kolumna z datą z potrójnymi paskami po obu stronach
            SizedBox(
              width: _ScheduleConstants.dateContainerWidth,
              child: Row(
                children: [
                  // Lewy pasek (potrójny)
                  SizedBox(
                    width: _ScheduleConstants.barWidth,
                    height: _ScheduleConstants.tripleItemHeight,
                    child: Column(
                      children: [
                        // Górna część - pierwszy typ
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: first.wasteType.color,
                            ),
                          ),
                        ),
                        // Środkowa część - drugi typ
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: second.wasteType.color,
                            ),
                          ),
                        ),
                        // Dolna część - trzeci typ
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: third.wasteType.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: _ScheduleConstants.horizontalPadding),
                  // Data i dzień tygodnia
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          first.day.toString(),
                          style: const TextStyle(
                            fontSize: _ScheduleConstants.dateFontSize,
                            height: _ScheduleConstants.dateLineHeight,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.textBlack,
                          ),
                        ),
                        Text(
                          getLocalizedDayName(
                            AppLocalizations.of(context)!,
                            first.dayOfWeek,
                          ),
                          style: const TextStyle(
                            fontSize: _ScheduleConstants.dayOfWeekFontSize,
                            color: AppTheme.grey400,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: _ScheduleConstants.horizontalPadding),
                  // Prawy pasek (potrójny)
                  SizedBox(
                    width: _ScheduleConstants.barWidth,
                    height: _ScheduleConstants.tripleItemHeight,
                    child: Column(
                      children: [
                        // Górna część - pierwszy typ
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: first.wasteType.color,
                            ),
                          ),
                        ),
                        // Środkowa część - drugi typ
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: second.wasteType.color,
                            ),
                          ),
                        ),
                        // Dolna część - trzeci typ
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: third.wasteType.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Nazwy typów odpadów wyrównane do prawej z potrójnymi paskami po prawej stronie
            Expanded(
              child: SizedBox(
                height: _ScheduleConstants.tripleItemHeight,
                child: Row(
                  children: [
                    // Tekst odpadów
                    Expanded(
                      child: Column(
                        children: [
                          // PIERWSZY TYP - górna trzecia
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                WasteTypeUtils.getLocalizedWasteTypeName(
                                  AppLocalizations.of(context)!,
                                  first.wasteType,
                                ).toUpperCase(),
                                style: const TextStyle(
                                  fontSize:
                                      _ScheduleConstants.wasteTypeFontSize,
                                  color: AppTheme.textBlack,
                                  height:
                                      _ScheduleConstants.wasteTypeLineHeight,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          // DRUGI TYP - środkowa trzecia
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                WasteTypeUtils.getLocalizedWasteTypeName(
                                  AppLocalizations.of(context)!,
                                  second.wasteType,
                                ).toUpperCase(),
                                style: const TextStyle(
                                  fontSize:
                                      _ScheduleConstants.wasteTypeFontSize,
                                  color: AppTheme.textBlack,
                                  height:
                                      _ScheduleConstants.wasteTypeLineHeight,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          // TRZECI TYP - dolna trzecia
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                WasteTypeUtils.getLocalizedWasteTypeName(
                                  AppLocalizations.of(context)!,
                                  third.wasteType,
                                ).toUpperCase(),
                                style: const TextStyle(
                                  fontSize:
                                      _ScheduleConstants.wasteTypeFontSize,
                                  color: AppTheme.textBlack,
                                  height:
                                      _ScheduleConstants.wasteTypeLineHeight,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: _ScheduleConstants.horizontalPadding),
                    // Potrójne paski po prawej stronie tekstu
                    SizedBox(
                      width: _ScheduleConstants.barWidth,
                      height: _ScheduleConstants.tripleItemHeight,
                      child: Column(
                        children: [
                          // Górna część - pierwszy typ
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: first.wasteType.color,
                              ),
                            ),
                          ),
                          // Środkowa część - drugi typ
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: second.wasteType.color,
                              ),
                            ),
                          ),
                          // Dolna część - trzeci typ
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: third.wasteType.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
