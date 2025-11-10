import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../models/waste_collection.dart';
import '../models/waste_type.dart';
import '../widgets/custom_app_bar.dart';
import '../utils/date_utils.dart';
import '../utils/waste_type_utils.dart';

class WasteDetailsScreen extends StatefulWidget {
  const WasteDetailsScreen({
    super.key,
    required this.collections,
    this.onLanguageChanged,
  });
  final List<WasteCollection> collections;
  final void Function(String)? onLanguageChanged;

  @override
  State<WasteDetailsScreen> createState() => _WasteDetailsScreenState();
}

class _WasteDetailsScreenState extends State<WasteDetailsScreen> {
  final Map<WasteType, bool> _expandedStates = {};

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: CustomAppBar(
        showBackButton: true,
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        padding: AppTheme.paddingBody,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Data i adres
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Lewa kolumna: Dzień i ulica
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.collections.first.day.toString(),
                      style: const TextStyle(
                        height: 0.8,
                        fontSize: 112,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textBlack,
                      ),
                    ),
                    const Text(
                      'JANA, PAWŁA',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF757575), // WCAG AA compliant
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                // Prawa kolumna: Godziny, miesiąc, dzień tygodnia
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.wb_sunny,
                            color: Color(0xFF757575),
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.collections.first.startTime,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF616161), // WCAG AA compliant
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.nights_stay,
                            color: Color(0xFF757575),
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.collections.first.endTime,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF616161), // WCAG AA compliant
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        getLocalizedMonthName(
                          AppLocalizations.of(context)!,
                          widget.collections.first.month,
                        ),
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppTheme.textBlack,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        getLocalizedDayName(
                          AppLocalizations.of(context)!,
                          widget.collections.first.dayOfWeek,
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF757575), // WCAG AA compliant
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Display all waste sections from collections
            ...widget.collections.map((collection) {
              return Column(
                children: [
                  _buildWasteSectionNew(collection),
                  //const SizedBox(height: 16),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _getImageForCollection(WasteCollection collection) {
    switch (collection.wasteType) {
      case WasteType.paper:
        return Center(
          child: Image.asset(
            'assets/img/papier.png',
            width: 190,
            height: 190,
            fit: BoxFit.contain,
          ),
        );
      case WasteType.glass:
        return Center(
          child: Image.asset(
            'assets/img/szk\u0142o.png',
            width: 190,
            height: 190,
            fit: BoxFit.contain,
          ),
        );
      case WasteType.metal:
        return Center(
          child: Image.asset(
            'assets/img/metale i tworzywa sztuczne.png',
            width: 190,
            height: 190,
            fit: BoxFit.contain,
          ),
        );
      case WasteType.bio:
        return Center(
          child: Image.asset(
            'assets/img/bio.png',
            width: 190,
            height: 190,
            fit: BoxFit.contain,
          ),
        );
      case WasteType.ash:
        return Center(
          child: Image.asset(
            'assets/img/popiol.png',
            width: 190,
            height: 190,
            fit: BoxFit.contain,
          ),
        );
      case WasteType.bulky:
        return Center(
          child: Image.asset(
            'assets/img/gabaryty.png',
            width: 190,
            height: 190,
            fit: BoxFit.contain,
          ),
        );
      case WasteType.elektro:
        return Center(
          child: Image.asset(
            'assets/img/elektro.png',
            width: 190,
            height: 190,
            fit: BoxFit.contain,
          ),
        );
      case WasteType.opony:
        return Center(
          child: Image.asset(
            'assets/img/opony.png',
            width: 190,
            height: 190,
            fit: BoxFit.contain,
          ),
        );
      case WasteType.mixed:
        return Center(
          child: Image.asset(
            'assets/img/zmieszane.png',
            width: 190,
            height: 190,
            fit: BoxFit.contain,
          ),
        );
      case WasteType.green:
        return Center(
          child: Image.asset(
            'assets/img/choinki.png',
            width: 190,
            height: 190,
            fit: BoxFit.contain,
          ),
        );
    }
  }

  Widget _buildWasteSectionNew(WasteCollection collection) {
    return Container(
      padding: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: collection.wasteType.color, width: 4),
          right: BorderSide(color: collection.wasteType.color, width: 4),
        ),
      ),
      child: Column(
        children: [
          // Kolorowy banner z nazwą odpadu
          Container(
            margin: collection.wasteType == WasteType.metal
                ? const EdgeInsets.symmetric(horizontal: 8.0)
                : EdgeInsets.zero,
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(
                  left: 4.0,
                  right: 4.0,
                  top: 1.0,
                ),
                decoration: BoxDecoration(
                  color: collection.wasteType.color,
                ),
                child: Text(
                  WasteTypeUtils.getLocalizedWasteTypeName(
                    AppLocalizations.of(context)!,
                    collection.wasteType,
                  ).toUpperCase(),
                  style: TextStyle(
                    fontSize: collection.wasteType == WasteType.metal ? 28 : 36,
                    height: 1,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.backgroundWhite,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          // Obrazek odpadu
          SizedBox(
            width: double.infinity,
            height: 190,
            child: ClipRRect(
            child: _getImageForCollection(collection),
          ),
          ),

          // Sekcja "JAK SEGREGOWAĆ?"
          Semantics(
            button: true,
            label: 'Jak segregować ${WasteTypeUtils.getLocalizedWasteTypeName(AppLocalizations.of(context)!, collection.wasteType)}',
            hint: _expandedStates[collection.wasteType] ?? false
                ? 'Dotknij aby zwinąć instrukcje'
                : 'Dotknij aby rozwinąć instrukcje segregacji',
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _expandedStates[collection.wasteType] =
                        !(_expandedStates[collection.wasteType] ?? false);
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.howToSegregate,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: AppTheme.grey700,
                      ),
                    ),
                    //const SizedBox(width: 8),
                    Icon(
                      _expandedStates[collection.wasteType] ?? false
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppTheme.grey600,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Rozszerzalna zawartość z instrukcjami
          if (_expandedStates[collection.wasteType] ?? false) ...[
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _getSegregationInstructions(collection.wasteType),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _getSegregationInstructions(WasteType wasteType) {
    switch (wasteType) {
      case WasteType.paper:
        return [
          Text(AppLocalizations.of(context)!.newspapersAndMagazines),
          Text(AppLocalizations.of(context)!.cardboardAndPaperboard),
          Text(AppLocalizations.of(context)!.officePaper),
          Text(AppLocalizations.of(context)!.booksWithoutCovers),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.doNotThrow,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(AppLocalizations.of(context)!.dirtyPaper),
          Text(AppLocalizations.of(context)!.wallpaper),
          Text(AppLocalizations.of(context)!.waxedPaper),
        ];
      case WasteType.glass:
        return [
          Text(AppLocalizations.of(context)!.glassBottles),
          Text(AppLocalizations.of(context)!.glassJars),
          Text(AppLocalizations.of(context)!.glassPackaging),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.doNotThrow,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(AppLocalizations.of(context)!.windowGlass),
          Text(AppLocalizations.of(context)!.mirrors),
          Text(AppLocalizations.of(context)!.porcelain),
        ];
      case WasteType.metal:
        return [
          Text(AppLocalizations.of(context)!.aluminumCans),
          Text(AppLocalizations.of(context)!.steelCans),
          Text(AppLocalizations.of(context)!.plasticPackaging),
          Text(AppLocalizations.of(context)!.drinkCartons),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.doNotThrow,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(AppLocalizations.of(context)!.batteries),
          Text(AppLocalizations.of(context)!.electronics),
        ];
      case WasteType.bio:
        return [
          Text(AppLocalizations.of(context)!.foodScraps),
          Text(AppLocalizations.of(context)!.eggShells),
          Text(AppLocalizations.of(context)!.coffeeAndTeaGrounds),
          Text(AppLocalizations.of(context)!.vegetableAndFruitPeels),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.doNotThrow,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(AppLocalizations.of(context)!.meatAndFish),
          Text(AppLocalizations.of(context)!.bones),
          Text(AppLocalizations.of(context)!.oil),
        ];
      case WasteType.ash:
        return [
          Text(AppLocalizations.of(context)!.furnaceAsh),
          Text(AppLocalizations.of(context)!.fireplaceAsh),
          Text(AppLocalizations.of(context)!.slag),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.doNotThrow,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(AppLocalizations.of(context)!.cigaretteAsh),
          Text(AppLocalizations.of(context)!.otherWaste),
        ];
      case WasteType.bulky:
        return [
          Text(AppLocalizations.of(context)!.furniture),
          Text(AppLocalizations.of(context)!.appliances),
          Text(AppLocalizations.of(context)!.bicycles),
          Text(AppLocalizations.of(context)!.mattresses),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.attention,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(AppLocalizations.of(context)!.callForCollection),
          Text(AppLocalizations.of(context)!.placeInFront),
        ];
      case WasteType.mixed:
        return [
          Text(AppLocalizations.of(context)!.nonRecyclableWaste),
          Text(AppLocalizations.of(context)!.dirtyPackaging),
          Text(AppLocalizations.of(context)!.hygienicWaste),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.doNotThrow,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(AppLocalizations.of(context)!.hazardousWaste),
          Text(AppLocalizations.of(context)!.electronics),
          Text(AppLocalizations.of(context)!.batteries),
        ];
      case WasteType.green:
        return [
          Text(AppLocalizations.of(context)!.grassClippings),
          Text(AppLocalizations.of(context)!.leaves),
          Text(AppLocalizations.of(context)!.branches),
          Text(AppLocalizations.of(context)!.hedgeTrimmings),
          Text(AppLocalizations.of(context)!.plantWaste),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.doNotThrowGreen,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(AppLocalizations.of(context)!.soilAndStones),
          Text(AppLocalizations.of(context)!.foodWaste),
        ];
      case WasteType.elektro:
        return [
          Text(AppLocalizations.of(context)!.computers),
          Text(AppLocalizations.of(context)!.phones),
          Text(AppLocalizations.of(context)!.televisions),
          Text(AppLocalizations.of(context)!.refrigerators),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.attention,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(AppLocalizations.of(context)!.callForCollection),
          Text(AppLocalizations.of(context)!.placeInFront),
        ];
      case WasteType.opony:
        return [
          Text(AppLocalizations.of(context)!.carTires),
          Text(AppLocalizations.of(context)!.bicycleTires),
          Text(AppLocalizations.of(context)!.motorcycleTires),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.attention,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(AppLocalizations.of(context)!.callForCollection),
          Text(AppLocalizations.of(context)!.placeInFront),
        ];
    }
  }
}
