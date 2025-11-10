import 'package:flutter/material.dart';
import '../models/disposal_location.dart';
import '../services/disposal_location_service.dart';
import '../widgets/custom_app_bar.dart';
import '../config/app_theme.dart';
import '../l10n/app_localizations.dart';

/// Ekran wyświetlający lokalizacje utylizacji odpadów
class DisposalLocationsScreen extends StatefulWidget {
  const DisposalLocationsScreen({super.key, this.wasteType});
  final String? wasteType;

  @override
  State<DisposalLocationsScreen> createState() =>
      _DisposalLocationsScreenState();
}

class _DisposalLocationsScreenState extends State<DisposalLocationsScreen> {
  final DisposalLocationService _locationService = DisposalLocationService();
  List<DisposalLocation> _locations = [];
  bool _isLoading = true;
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.wasteType;
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      List<DisposalLocation> locations;

      if (_selectedType != null) {
        locations = await _locationService.getLocationsForWasteType(
          _selectedType!,
        );
      } else {
        locations = await _locationService.getAllLocations();
      }

      if (!mounted) return;
      setState(() {
        _locations = locations;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${AppLocalizations.of(context)!.loadingLocationsError}: $e')));
    }
  }

  Future<void> _filterByType(String? type) async {
    setState(() {
      _selectedType = type;
    });
    await _loadLocations();
  }

  Future<void> _searchLocations(String query) async {
    if (query.isEmpty) {
      await _loadLocations();
      return;
    }

    final results = await _locationService.searchLocations(query);
    setState(() {
      _locations = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: l10n.disposalLocations,
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Pasek wyszukiwania
          Container(
            padding: AppTheme.paddingAll,
            child: TextField(
              onChanged: _searchLocations,
              decoration: InputDecoration(
                hintText: l10n.searchLocationPlaceholder,
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
          ),

          // Filtry typu
          Container(
            height: 50,
            padding: AppTheme.paddingHorizontal,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _getLocationTypes().length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(l10n.all),
                      selected: _selectedType == null,
                      onSelected: (selected) => _filterByType(null),
                      selectedColor: Colors.green.shade100,
                      checkmarkColor: Colors.green,
                    ),
                  );
                }

                final type = _getLocationTypes()[index - 1];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(type),
                    selected: _selectedType == type,
                    onSelected: (selected) =>
                        _filterByType(selected ? type : null),
                    selectedColor: Colors.green.shade100,
                    checkmarkColor: Colors.green,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Lista lokalizacji
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _locations.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: AppTheme.paddingHorizontal,
                    itemCount: _locations.length,
                    itemBuilder: (context, index) {
                      final location = _locations[index];
                      return _buildLocationCard(location);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noLocations,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.noLocationsForFilters,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(DisposalLocation location) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showLocationDetails(location),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: AppTheme.paddingAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nagłówek z nazwą i typem
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getLocationIcon(location.type),
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          location.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textBlack,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            location.type,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Adres
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      location.address,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Telefon
              Row(
                children: [
                  Icon(Icons.phone, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Text(
                    location.phone,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Godziny otwarcia
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getCurrentOpeningHours(location),
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Usługi
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: location.services
                    .take(3)
                    .map(
                      (service) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          service,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLocationDetails(DisposalLocation location) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildLocationDetailsSheet(location),
    );
  }

  Widget _buildLocationDetailsSheet(DisposalLocation location) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Zawartość
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nagłówek
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getLocationIcon(location.type),
                          color: Colors.green,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              location.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textBlack,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                location.type,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Informacje kontaktowe
                  _buildInfoSection(
                    'Informacje kontaktowe',
                    Icons.contact_phone,
                    [
                      _buildInfoRow(
                        Icons.location_on,
                        'Adres',
                        location.address,
                      ),
                      _buildInfoRow(Icons.phone, 'Telefon', location.phone),
                      _buildInfoRow(Icons.email, 'Email', location.email),
                      _buildInfoRow(
                        Icons.language,
                        'Strona internetowa',
                        location.website,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Godziny otwarcia
                  _buildInfoSection('Godziny otwarcia', Icons.access_time, [
                    _buildInfoRow(
                      Icons.calendar_today,
                      'Poniedziałek',
                      location.getOpeningHoursForDay('monday'),
                    ),
                    _buildInfoRow(
                      Icons.calendar_today,
                      'Wtorek',
                      location.getOpeningHoursForDay('tuesday'),
                    ),
                    _buildInfoRow(
                      Icons.calendar_today,
                      'Środa',
                      location.getOpeningHoursForDay('wednesday'),
                    ),
                    _buildInfoRow(
                      Icons.calendar_today,
                      'Czwartek',
                      location.getOpeningHoursForDay('thursday'),
                    ),
                    _buildInfoRow(
                      Icons.calendar_today,
                      'Piątek',
                      location.getOpeningHoursForDay('friday'),
                    ),
                    _buildInfoRow(
                      Icons.calendar_today,
                      'Sobota',
                      location.getOpeningHoursForDay('saturday'),
                    ),
                    _buildInfoRow(
                      Icons.calendar_today,
                      'Niedziela',
                      location.getOpeningHoursForDay('sunday'),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // Usługi
                  _buildInfoSection(
                    'Usługi',
                    Icons.room_service,
                    location.services
                        .map(
                          (service) => _buildInfoRow(Icons.check, service, ''),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 24),

                  // Uwagi
                  if (location.notes != null)
                    _buildInfoSection('Uwagi', Icons.info, [
                      _buildInfoRow(Icons.note, location.notes!, ''),
                    ]),

                  const Spacer(),

                  // Przyciski akcji
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Otwórz mapy
                          },
                          icon: const Icon(Icons.map),
                          label: Text(AppLocalizations.of(context)!.map),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Zadzwoń
                          },
                          icon: const Icon(Icons.phone),
                          label: Text(AppLocalizations.of(context)!.call),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.green, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textBlack,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getLocationTypes() {
    return [
      'PSZOK',
      'Apteka',
      'Sklep RTV/AGD',
      'Organizacja charytatywna',
      'Warsztat samochodowy',
      'Biblioteka',
      'Kontener',
    ];
  }

  IconData _getLocationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'pszok':
        return Icons.recycling;
      case 'apteka':
        return Icons.local_pharmacy;
      case 'sklep rtv/agd':
        return Icons.store;
      case 'organizacja charytatywna':
        return Icons.volunteer_activism;
      case 'warsztat samochodowy':
        return Icons.car_repair;
      case 'biblioteka':
        return Icons.library_books;
      case 'kontener':
        return Icons.inventory;
      default:
        return Icons.location_on;
    }
  }

  String _getCurrentOpeningHours(DisposalLocation location) {
    final now = DateTime.now();
    final dayNames = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    final currentDay = dayNames[now.weekday - 1];
    return location.getOpeningHoursForDay(currentDay);
  }
}
