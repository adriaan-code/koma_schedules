import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../models/api_models.dart';
import '../models/waste_type.dart';
import '../services/api_service.dart';
import '../widgets/koma_header.dart';

/// Ekran bazy wiedzy o odpadach z wyszukiwaniem
class WasteSearchScreen extends StatefulWidget {
  const WasteSearchScreen({super.key});

  @override
  State<WasteSearchScreen> createState() => _WasteSearchScreenState();
}

class _WasteSearchScreenState extends State<WasteSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ApiService _apiService = ApiService();

  List<ApiWasteSearchResult> _suggestions = [];
  bool _isLoading = false;
  String? _errorMessage;
  ApiWasteSearchResult? _selectedWaste;
  String _lastSearchQuery = '';
  bool _isProgrammaticChange = false; // Flaga dla programmatycznych zmian

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // Ignoruj programmatyczne zmiany
    if (_isProgrammaticChange) {
      return;
    }

    final query = _searchController.text.trim();

    // Jeśli użytkownik zmienił tekst, wyczyść wybór
    if (_selectedWaste != null) {
      if (mounted) {
        setState(() {
          _selectedWaste = null;
          _suggestions = [];
          _errorMessage = null;
          _lastSearchQuery = '';
        });
      }
    }

    // Wyszukaj tylko jeśli nie ma wybranego elementu
    if (_selectedWaste == null) {
      if (query.length >= 3) {
        _performSearch(query);
      } else {
        if (mounted) {
          setState(() {
            _suggestions = [];
            _errorMessage = null;
            _lastSearchQuery = '';
          });
        }
      }
    }
  }

  Future<void> _performSearch(String query) async {
    final l10n = AppLocalizations.of(context)!;

    if (query.trim().length < 3) {
      if (mounted) {
        setState(() {
          _errorMessage = l10n.minThreeCharacters;
          _suggestions = [];
          _lastSearchQuery = '';
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _lastSearchQuery = query.trim();
      });
    }

    try {
      final results = await _apiService.searchWaste(query);
      if (mounted) {
        setState(() {
          _suggestions = results;
          _isLoading = false;

          if (results.isEmpty) {
            _errorMessage = l10n.noResultsFor(_lastSearchQuery);
          } else if (results.length == 1) {
            // Jeśli jest tylko jeden wynik, automatycznie go wybierz
            _selectedWaste = results.first;
            _suggestions = []; // Ukryj listę sugestii
            _errorMessage = null;
          }
        });
      }
    } catch (e) {
      if (const bool.fromEnvironment('dart.vm.product') == false) {
        debugPrint('Search error: $e');
      }

      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
          _suggestions = [];
          _isLoading = false;
        });
      }
    }
  }

  void _selectWaste(ApiWasteSearchResult waste) {
    if (mounted) {
      setState(() {
        _selectedWaste = waste;
        _suggestions = []; // Ukryj listę sugestii po wybraniu
        _errorMessage = null; // Wyczyść komunikat o błędzie
      });

      // Ustaw tekst programmatycznie (bez wywoływania listenera)
      _isProgrammaticChange = true;
      _searchController.text = waste.waste_name;
      _isProgrammaticChange = false;
    }
  }

  void _clearSelection() {
    if (mounted) {
      setState(() {
        _selectedWaste = null;
        _suggestions = [];
        _errorMessage = null;
        _lastSearchQuery = '';
      });

      // Wyczyść tekst programmatycznie (bez wywoływania listenera)
      _isProgrammaticChange = true;
      _searchController.clear();
      _isProgrammaticChange = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header z logo KOMA
              KomaHeader.logoOnly(),

              // Header z wyszukiwarką
              _buildSearchHeader(),

              // Zawartość
              if (_selectedWaste != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingMedium,
                  ),
                  child: _WasteDetailsCard(
                    waste: _selectedWaste!,
                    onClear: _clearSelection,
                  ),
                ),

              // Dodatkowy padding na dole dla bezpieczeństwa
              const SizedBox(height: AppTheme.spacingLarge),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Padding(
      padding: const EdgeInsets.only(
        right: AppTheme.spacingMedium,
        left: AppTheme.spacingMedium,
      ),
      child: Column(
        children: [
          //const SizedBox(height: 40), // Zmniejszono z 80 na 40
          // Tytuł - zawsze widoczny
          const _SearchTitle(),
          const SizedBox(height: AppTheme.spacingSmall),
          // Pole wyszukiwania - ukryj gdy jest wybrany element
          if (_selectedWaste == null)
            _SearchField(
              controller: _searchController,
              focusNode: _searchFocusNode,
            ),
          // Sugestie - pokazuj tylko gdy nie ma wybranego elementu
          if (_suggestions.isNotEmpty && _selectedWaste == null)
            _SuggestionsList(suggestions: _suggestions, onSelect: _selectWaste),
          // Loading
          if (_isLoading) const _LoadingIndicator(),
          // Komunikat o braku wyników
          if (!_isLoading &&
              _errorMessage != null &&
              _lastSearchQuery.isNotEmpty &&
              _selectedWaste == null)
            _NoResultsMessage(message: _errorMessage!),
        ],
      ),
    );
  }
}

/// Tytuł ekranu wyszukiwania
class _SearchTitle extends StatelessWidget {
  const _SearchTitle();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        children: [
          Text(
            l10n.searchWaste,
            style: const TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic,
              color: AppTheme.textPrimary,
            ),
          ),
          Text(
            l10n.waste,
            style: const TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w900,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Pole wyszukiwania
class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.focusNode});

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppTheme.backgroundGreyMedium,
        borderRadius: BorderRadius.circular(100),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          hintText: l10n.enterWasteName,
          hintStyle: const TextStyle(
            color: AppTheme.textTertiary,
            fontSize: AppTheme.fontSizeMedium,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppTheme.primaryBlue,
            size: 24,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMedium,
            vertical: AppTheme.spacingMedium,
          ),
        ),
        style: const TextStyle(
          fontSize: AppTheme.fontSizeMedium,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }
}

/// Lista sugestii
class _SuggestionsList extends StatelessWidget {
  const _SuggestionsList({required this.suggestions, required this.onSelect});

  final List<ApiWasteSearchResult> suggestions;
  final void Function(ApiWasteSearchResult) onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: AppTheme.spacingSmall),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppTheme.textBlack.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: suggestions.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return _SuggestionItem(
            key: ValueKey('${suggestion.id}_$index'), // Unikalny klucz
            suggestion: suggestion,
            onTap: () => onSelect(suggestion),
          );
        },
      ),
    );
  }
}

/// Element sugestii
class _SuggestionItem extends StatelessWidget {
  const _SuggestionItem({
    super.key,
    required this.suggestion,
    required this.onTap,
  });

  final ApiWasteSearchResult suggestion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Row(
          children: [
            const Icon(Icons.search, size: 16, color: AppTheme.textSecondary),
            const SizedBox(width: AppTheme.spacingSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    suggestion.waste_name,
                    style: const TextStyle(
                      fontSize: AppTheme.fontSizeMedium - 2,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  if (suggestion.waste_group.isNotEmpty)
                    Text(
                      suggestion.waste_group,
                      style: const TextStyle(
                        fontSize: AppTheme.fontSizeSmall,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Wskaźnik ładowania
class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(top: AppTheme.spacingSmall),
      padding: const EdgeInsets.all(AppTheme.spacingMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(width: AppTheme.spacingSmall),
          Text(
            l10n.searching,
            style: const TextStyle(
              fontSize: AppTheme.fontSizeMedium - 2,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Komunikat o braku wyników
class _NoResultsMessage extends StatelessWidget {
  const _NoResultsMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: AppTheme.spacingSmall),
      padding: const EdgeInsets.all(AppTheme.spacingMedium),
      decoration: BoxDecoration(
        color: AppTheme.warningOrange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        border: Border.all(color: AppTheme.warningOrange.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppTheme.warningOrange, size: 20),
          const SizedBox(width: AppTheme.spacingSmall),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: AppTheme.fontSizeMedium - 2,
                color: AppTheme.warningOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Karta ze szczegółami odpadu
class _WasteDetailsCard extends StatelessWidget {
  const _WasteDetailsCard({required this.waste, required this.onClear});

  final ApiWasteSearchResult waste;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nazwa wyszukiwanego odpadu nad całym boxem
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(
              waste.waste_name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: waste.containerColor, width: 4),
                  right: BorderSide(color: waste.containerColor, width: 4),
                ),
              ),
          child: Column(
            children: [
              // Kolorowy banner z nazwą odpadu (jak w waste_details_screen)
              Container(
                margin: waste.containerWasteType == WasteType.metal
                    ? const EdgeInsets.symmetric(horizontal: 8.0)
                    : EdgeInsets.zero,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 4.0,
                      right: 4.0,
                      top: 1.0,
                      bottom: 1.0,
                    ),
                    decoration: BoxDecoration(
                      color: waste.containerColor,
                    ),
                    child: Text(
                      waste.waste_group.toUpperCase(),
                      style: TextStyle(
                        fontSize: waste.containerWasteType == WasteType.metal ? 24 : 28,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.backgroundWhite,
                        letterSpacing: 1.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

              // Nazwa pojemnika pod bannerem po prawej stronie
              Padding(
                padding: const EdgeInsets.only(
                  //top: 8.0,
                  right: 8.0,
                  //bottom: 8.0,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    waste.main_container.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: waste.containerColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

              // Zdjęcie frakcji pod bannerem
              SizedBox(
                width: double.infinity,
                height: 120,
                child: ClipRRect(
                  child: _getImageForWaste(waste.containerWasteType),
                ),
              ),

              // Zawartość karty
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header z nazwą
                    const SizedBox(height: AppTheme.spacingLarge),

                    // Przycisk "Wyszukaj ponownie"
                    _SearchAgainButton(onPressed: onClear),
                  ],
                ),
              ),
            ],
          ),
          ),
        ),
        ],
      ),
    );
  }

  Widget _getImageForWaste(WasteType wasteType) {
    switch (wasteType) {
      case WasteType.paper:
        return Center(
          child: Image.asset(
            'assets/img/papier.png',
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
        );
      case WasteType.glass:
        return Center(
          child: Image.asset(
            'assets/img/szkło.png',
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
        );
      case WasteType.metal:
        return Center(
          child: Image.asset(
            'assets/img/metale i tworzywa sztuczne.png',
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
        );
      case WasteType.bio:
        return Center(
          child: Image.asset(
            'assets/img/bio.png',
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
        );
      case WasteType.ash:
        return Center(
          child: Image.asset(
            'assets/img/popiol.png',
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
        );
      case WasteType.bulky:
        return Center(
          child: Image.asset(
            'assets/img/gabaryty.png',
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
        );
      case WasteType.elektro:
        return Center(
          child: Image.asset(
            'assets/img/elektro.png',
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
        );
      case WasteType.opony:
        return Center(
          child: Image.asset(
            'assets/img/opony.png',
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
        );
      case WasteType.mixed:
        return Center(
          child: Image.asset(
            'assets/img/zmieszane.png',
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
        );
      case WasteType.green:
        return Center(
          child: Image.asset(
            'assets/img/choinki.png',
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
        );
    }
  }
}

/// Header karty szczegółów

/// Przycisk wyszukaj ponownie
class _SearchAgainButton extends StatelessWidget {
  const _SearchAgainButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: onPressed,
          child: Center(
            child: Text(
              l10n.searchAgain.toUpperCase(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
