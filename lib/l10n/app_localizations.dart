import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl'),
    Locale('uk'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In pl, this message translates to:
  /// **'Aplikacja KOMA'**
  String get appTitle;

  /// No description provided for @koma.
  ///
  /// In pl, this message translates to:
  /// **'KOMA'**
  String get koma;

  /// No description provided for @komaServices.
  ///
  /// In pl, this message translates to:
  /// **'KOMA USŁUGI KOMUNALNE'**
  String get komaServices;

  /// No description provided for @back.
  ///
  /// In pl, this message translates to:
  /// **'POWRÓT'**
  String get back;

  /// No description provided for @returnButton.
  ///
  /// In pl, this message translates to:
  /// **'POWRÓT'**
  String get returnButton;

  /// No description provided for @cancel.
  ///
  /// In pl, this message translates to:
  /// **'Anuluj'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In pl, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @search.
  ///
  /// In pl, this message translates to:
  /// **'Szukaj'**
  String get search;

  /// No description provided for @loading.
  ///
  /// In pl, this message translates to:
  /// **'Ładowanie...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In pl, this message translates to:
  /// **'Błąd'**
  String get error;

  /// No description provided for @noData.
  ///
  /// In pl, this message translates to:
  /// **'Brak danych'**
  String get noData;

  /// No description provided for @tryAgain.
  ///
  /// In pl, this message translates to:
  /// **'Spróbuj ponownie'**
  String get tryAgain;

  /// No description provided for @schedule.
  ///
  /// In pl, this message translates to:
  /// **'Harmonogram'**
  String get schedule;

  /// No description provided for @knowledgeBase.
  ///
  /// In pl, this message translates to:
  /// **'Baza wiedzy'**
  String get knowledgeBase;

  /// No description provided for @shop.
  ///
  /// In pl, this message translates to:
  /// **'Sklep KOMA'**
  String get shop;

  /// No description provided for @bokPortal.
  ///
  /// In pl, this message translates to:
  /// **'BOK Portal'**
  String get bokPortal;

  /// No description provided for @notifications.
  ///
  /// In pl, this message translates to:
  /// **'Powiadomienia'**
  String get notifications;

  /// No description provided for @settings.
  ///
  /// In pl, this message translates to:
  /// **'Ustawienia'**
  String get settings;

  /// No description provided for @notificationsComingSoon.
  ///
  /// In pl, this message translates to:
  /// **'Powiadomienia - wkrótce dostępne'**
  String get notificationsComingSoon;

  /// No description provided for @addressSearch.
  ///
  /// In pl, this message translates to:
  /// **'Wyszukiwanie adresu'**
  String get addressSearch;

  /// No description provided for @searchAddress.
  ///
  /// In pl, this message translates to:
  /// **'WYSZUKAJ'**
  String get searchAddress;

  /// No description provided for @address.
  ///
  /// In pl, this message translates to:
  /// **'ADRES'**
  String get address;

  /// No description provided for @useLocation.
  ///
  /// In pl, this message translates to:
  /// **'Użyj lokalizacji'**
  String get useLocation;

  /// No description provided for @gettingLocation.
  ///
  /// In pl, this message translates to:
  /// **'Pobieranie lokalizacji...'**
  String get gettingLocation;

  /// No description provided for @locationError.
  ///
  /// In pl, this message translates to:
  /// **'Błąd lokalizacji'**
  String get locationError;

  /// No description provided for @gpsLocation.
  ///
  /// In pl, this message translates to:
  /// **'Lokalizacja GPS'**
  String get gpsLocation;

  /// No description provided for @coordinates.
  ///
  /// In pl, this message translates to:
  /// **'Współrzędne'**
  String get coordinates;

  /// No description provided for @selectSector.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz sektor'**
  String get selectSector;

  /// No description provided for @selectPrefix.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz prefiks'**
  String get selectPrefix;

  /// No description provided for @selectLocality.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz miejscowość'**
  String get selectLocality;

  /// No description provided for @selectCity.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz miasto'**
  String get selectCity;

  /// No description provided for @selectStreet.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz ulicę'**
  String get selectStreet;

  /// No description provided for @selectProperty.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz posesję'**
  String get selectProperty;

  /// No description provided for @selectPropertyNumber.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz numer posesji'**
  String get selectPropertyNumber;

  /// No description provided for @noProperties.
  ///
  /// In pl, this message translates to:
  /// **'Brak posesji - sprawdź logi'**
  String get noProperties;

  /// No description provided for @showSchedule.
  ///
  /// In pl, this message translates to:
  /// **'POKAŻ HARMONOGRAM'**
  String get showSchedule;

  /// No description provided for @loadingSectors.
  ///
  /// In pl, this message translates to:
  /// **'Ładowanie sektorów...'**
  String get loadingSectors;

  /// No description provided for @loadingSectorsError.
  ///
  /// In pl, this message translates to:
  /// **'Błąd ładowania sektorów'**
  String get loadingSectorsError;

  /// No description provided for @selectSectorAndLocality.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz sektor i miejscowość'**
  String get selectSectorAndLocality;

  /// No description provided for @toFindSchedule.
  ///
  /// In pl, this message translates to:
  /// **'Aby znaleźć harmonogram, wybierz adres z listy poniżej lub użyj wyszukiwania ręcznego.'**
  String get toFindSchedule;

  /// No description provided for @favoriteLocations.
  ///
  /// In pl, this message translates to:
  /// **'Ulubione lokalizacje'**
  String get favoriteLocations;

  /// No description provided for @recentLocations.
  ///
  /// In pl, this message translates to:
  /// **'Ostatnie lokalizacje'**
  String get recentLocations;

  /// No description provided for @recentSearches.
  ///
  /// In pl, this message translates to:
  /// **'Ostatnie wyszukiwania'**
  String get recentSearches;

  /// No description provided for @addedToFavorites.
  ///
  /// In pl, this message translates to:
  /// **'Dodano do ulubionych'**
  String get addedToFavorites;

  /// No description provided for @removedFromFavorites.
  ///
  /// In pl, this message translates to:
  /// **'Usunięto z ulubionych'**
  String get removedFromFavorites;

  /// No description provided for @orSelectNewLocation.
  ///
  /// In pl, this message translates to:
  /// **'Lub wybierz nową lokalizację używając list rozwijanych powyżej'**
  String get orSelectNewLocation;

  /// No description provided for @wasteSchedule.
  ///
  /// In pl, this message translates to:
  /// **'Harmonogram odpadów'**
  String get wasteSchedule;

  /// No description provided for @wasteCollection.
  ///
  /// In pl, this message translates to:
  /// **'Odbiór odpadów'**
  String get wasteCollection;

  /// No description provided for @today.
  ///
  /// In pl, this message translates to:
  /// **'Dzisiaj'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In pl, this message translates to:
  /// **'Jutro'**
  String get tomorrow;

  /// No description provided for @nextWeek.
  ///
  /// In pl, this message translates to:
  /// **'W przyszłym tygodniu'**
  String get nextWeek;

  /// No description provided for @wasteToday.
  ///
  /// In pl, this message translates to:
  /// **'Odpady na dzisiaj'**
  String get wasteToday;

  /// No description provided for @todayCollection.
  ///
  /// In pl, this message translates to:
  /// **'Dzisiaj odbiera się: '**
  String get todayCollection;

  /// No description provided for @wasteType.
  ///
  /// In pl, this message translates to:
  /// **'Typ odpadu'**
  String get wasteType;

  /// No description provided for @collectionTime.
  ///
  /// In pl, this message translates to:
  /// **'Czas odbioru'**
  String get collectionTime;

  /// No description provided for @container.
  ///
  /// In pl, this message translates to:
  /// **'Pojemnik'**
  String get container;

  /// No description provided for @frequency.
  ///
  /// In pl, this message translates to:
  /// **'Częstotliwość'**
  String get frequency;

  /// No description provided for @wasteDatabase.
  ///
  /// In pl, this message translates to:
  /// **'Baza Odpadów'**
  String get wasteDatabase;

  /// No description provided for @searchWaste.
  ///
  /// In pl, this message translates to:
  /// **'WYSZUKAJ'**
  String get searchWaste;

  /// No description provided for @waste.
  ///
  /// In pl, this message translates to:
  /// **'ODPADY'**
  String get waste;

  /// No description provided for @enterWasteName.
  ///
  /// In pl, this message translates to:
  /// **'Wpisz nazwę odpadu'**
  String get enterWasteName;

  /// No description provided for @searching.
  ///
  /// In pl, this message translates to:
  /// **'Wyszukiwanie...'**
  String get searching;

  /// No description provided for @noResultsFor.
  ///
  /// In pl, this message translates to:
  /// **'Brak odpadów zaczynających się na \"{query}\"'**
  String noResultsFor(String query);

  /// No description provided for @whereToThrow.
  ///
  /// In pl, this message translates to:
  /// **'Gdzie wyrzucić:'**
  String get whereToThrow;

  /// No description provided for @or.
  ///
  /// In pl, this message translates to:
  /// **'lub:'**
  String get or;

  /// No description provided for @wasteGroup.
  ///
  /// In pl, this message translates to:
  /// **'Grupa odpadów:'**
  String get wasteGroup;

  /// No description provided for @searchAgain.
  ///
  /// In pl, this message translates to:
  /// **'Wyszukaj ponownie'**
  String get searchAgain;

  /// No description provided for @checkWhereToThrow.
  ///
  /// In pl, this message translates to:
  /// **'Sprawdź gdzie wyrzucić'**
  String get checkWhereToThrow;

  /// No description provided for @minThreeCharacters.
  ///
  /// In pl, this message translates to:
  /// **'Wpisz co najmniej 3 znaki, aby wyszukać odpady'**
  String get minThreeCharacters;

  /// No description provided for @howToSegregate.
  ///
  /// In pl, this message translates to:
  /// **'JAK SEGREGOWAĆ?'**
  String get howToSegregate;

  /// No description provided for @segregationGuide.
  ///
  /// In pl, this message translates to:
  /// **'Przewodnik segregacji'**
  String get segregationGuide;

  /// No description provided for @instructions.
  ///
  /// In pl, this message translates to:
  /// **'Instrukcje'**
  String get instructions;

  /// No description provided for @whatCanBeThrown.
  ///
  /// In pl, this message translates to:
  /// **'Co można wyrzucić'**
  String get whatCanBeThrown;

  /// No description provided for @whatCannotBeThrown.
  ///
  /// In pl, this message translates to:
  /// **'Czego nie można wyrzucić'**
  String get whatCannotBeThrown;

  /// No description provided for @preparation.
  ///
  /// In pl, this message translates to:
  /// **'Przygotowanie'**
  String get preparation;

  /// No description provided for @notes.
  ///
  /// In pl, this message translates to:
  /// **'Uwagi'**
  String get notes;

  /// No description provided for @attention.
  ///
  /// In pl, this message translates to:
  /// **'Uwaga:'**
  String get attention;

  /// No description provided for @doNotThrow.
  ///
  /// In pl, this message translates to:
  /// **'Nie wrzucaj:'**
  String get doNotThrow;

  /// No description provided for @mixed.
  ///
  /// In pl, this message translates to:
  /// **'Zmieszane'**
  String get mixed;

  /// No description provided for @paper.
  ///
  /// In pl, this message translates to:
  /// **'Papier'**
  String get paper;

  /// No description provided for @glass.
  ///
  /// In pl, this message translates to:
  /// **'Szkło'**
  String get glass;

  /// No description provided for @plastic.
  ///
  /// In pl, this message translates to:
  /// **'Metale i tworzywa sztuczne'**
  String get plastic;

  /// No description provided for @bio.
  ///
  /// In pl, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @ash.
  ///
  /// In pl, this message translates to:
  /// **'Popiół'**
  String get ash;

  /// No description provided for @bulky.
  ///
  /// In pl, this message translates to:
  /// **'Gabaryty'**
  String get bulky;

  /// No description provided for @green.
  ///
  /// In pl, this message translates to:
  /// **'Odpady zielone'**
  String get green;

  /// No description provided for @newspapersAndMagazines.
  ///
  /// In pl, this message translates to:
  /// **'• Gazety i czasopisma'**
  String get newspapersAndMagazines;

  /// No description provided for @cardboardAndPaperboard.
  ///
  /// In pl, this message translates to:
  /// **'• Kartony i tektury'**
  String get cardboardAndPaperboard;

  /// No description provided for @officePaper.
  ///
  /// In pl, this message translates to:
  /// **'• Papier biurowy'**
  String get officePaper;

  /// No description provided for @booksWithoutCovers.
  ///
  /// In pl, this message translates to:
  /// **'• Książki (bez okładek)'**
  String get booksWithoutCovers;

  /// No description provided for @dirtyPaper.
  ///
  /// In pl, this message translates to:
  /// **'• Papieru zabrudzonego'**
  String get dirtyPaper;

  /// No description provided for @wallpaper.
  ///
  /// In pl, this message translates to:
  /// **'• Tapet'**
  String get wallpaper;

  /// No description provided for @waxedPaper.
  ///
  /// In pl, this message translates to:
  /// **'• Papieru woskowanego'**
  String get waxedPaper;

  /// No description provided for @glassBottles.
  ///
  /// In pl, this message translates to:
  /// **'• Butelki szklane'**
  String get glassBottles;

  /// No description provided for @glassJars.
  ///
  /// In pl, this message translates to:
  /// **'• Słoiki szklane'**
  String get glassJars;

  /// No description provided for @glassPackaging.
  ///
  /// In pl, this message translates to:
  /// **'• Opakowania szklane'**
  String get glassPackaging;

  /// No description provided for @windowGlass.
  ///
  /// In pl, this message translates to:
  /// **'• Szkła okiennego'**
  String get windowGlass;

  /// No description provided for @mirrors.
  ///
  /// In pl, this message translates to:
  /// **'• Luster'**
  String get mirrors;

  /// No description provided for @porcelain.
  ///
  /// In pl, this message translates to:
  /// **'• Porcelany'**
  String get porcelain;

  /// No description provided for @aluminumCans.
  ///
  /// In pl, this message translates to:
  /// **'• Puszki aluminiowe'**
  String get aluminumCans;

  /// No description provided for @steelCans.
  ///
  /// In pl, this message translates to:
  /// **'• Puszki stalowe'**
  String get steelCans;

  /// No description provided for @plasticPackaging.
  ///
  /// In pl, this message translates to:
  /// **'• Opakowania z tworzyw sztucznych'**
  String get plasticPackaging;

  /// No description provided for @drinkCartons.
  ///
  /// In pl, this message translates to:
  /// **'• Kartony po napojach'**
  String get drinkCartons;

  /// No description provided for @batteries.
  ///
  /// In pl, this message translates to:
  /// **'• Baterii'**
  String get batteries;

  /// No description provided for @electronics.
  ///
  /// In pl, this message translates to:
  /// **'• Elektroniki'**
  String get electronics;

  /// No description provided for @foodScraps.
  ///
  /// In pl, this message translates to:
  /// **'• Resztki jedzenia'**
  String get foodScraps;

  /// No description provided for @eggShells.
  ///
  /// In pl, this message translates to:
  /// **'• Skorupki jaj'**
  String get eggShells;

  /// No description provided for @coffeeAndTeaGrounds.
  ///
  /// In pl, this message translates to:
  /// **'• Fusy kawy i herbaty'**
  String get coffeeAndTeaGrounds;

  /// No description provided for @vegetableAndFruitPeels.
  ///
  /// In pl, this message translates to:
  /// **'• Obierki warzyw i owoców'**
  String get vegetableAndFruitPeels;

  /// No description provided for @meatAndFish.
  ///
  /// In pl, this message translates to:
  /// **'• Mięsa i ryb'**
  String get meatAndFish;

  /// No description provided for @bones.
  ///
  /// In pl, this message translates to:
  /// **'• Kości'**
  String get bones;

  /// No description provided for @oil.
  ///
  /// In pl, this message translates to:
  /// **'• Oleju'**
  String get oil;

  /// No description provided for @furnaceAsh.
  ///
  /// In pl, this message translates to:
  /// **'• Popiół z pieców'**
  String get furnaceAsh;

  /// No description provided for @fireplaceAsh.
  ///
  /// In pl, this message translates to:
  /// **'• Popiół z kominków'**
  String get fireplaceAsh;

  /// No description provided for @slag.
  ///
  /// In pl, this message translates to:
  /// **'• Żużel'**
  String get slag;

  /// No description provided for @cigaretteAsh.
  ///
  /// In pl, this message translates to:
  /// **'• Popiołu z papierosów'**
  String get cigaretteAsh;

  /// No description provided for @otherWaste.
  ///
  /// In pl, this message translates to:
  /// **'• Innych odpadów'**
  String get otherWaste;

  /// No description provided for @furniture.
  ///
  /// In pl, this message translates to:
  /// **'• Meble'**
  String get furniture;

  /// No description provided for @appliances.
  ///
  /// In pl, this message translates to:
  /// **'• Sprzęt AGD'**
  String get appliances;

  /// No description provided for @bicycles.
  ///
  /// In pl, this message translates to:
  /// **'• Rowery'**
  String get bicycles;

  /// No description provided for @mattresses.
  ///
  /// In pl, this message translates to:
  /// **'• Materace'**
  String get mattresses;

  /// No description provided for @callForCollection.
  ///
  /// In pl, this message translates to:
  /// **'• Zgłoś odbiór telefonicznie'**
  String get callForCollection;

  /// No description provided for @placeInFront.
  ///
  /// In pl, this message translates to:
  /// **'• Ustaw przed posesją'**
  String get placeInFront;

  /// No description provided for @grassClippings.
  ///
  /// In pl, this message translates to:
  /// **'• Skoszona trawa'**
  String get grassClippings;

  /// No description provided for @leaves.
  ///
  /// In pl, this message translates to:
  /// **'• Liście'**
  String get leaves;

  /// No description provided for @branches.
  ///
  /// In pl, this message translates to:
  /// **'• Gałęzie'**
  String get branches;

  /// No description provided for @hedgeTrimmings.
  ///
  /// In pl, this message translates to:
  /// **'• Przycięte żywopłoty'**
  String get hedgeTrimmings;

  /// No description provided for @plantWaste.
  ///
  /// In pl, this message translates to:
  /// **'• Odpady roślinne'**
  String get plantWaste;

  /// No description provided for @doNotThrowGreen.
  ///
  /// In pl, this message translates to:
  /// **'• Nie wrzucaj:'**
  String get doNotThrowGreen;

  /// No description provided for @soilAndStones.
  ///
  /// In pl, this message translates to:
  /// **'• Ziemia i kamienie'**
  String get soilAndStones;

  /// No description provided for @foodWaste.
  ///
  /// In pl, this message translates to:
  /// **'• Odpady spożywcze'**
  String get foodWaste;

  /// No description provided for @nonRecyclableWaste.
  ///
  /// In pl, this message translates to:
  /// **'• Odpady, które nie nadają się do segregacji'**
  String get nonRecyclableWaste;

  /// No description provided for @dirtyPackaging.
  ///
  /// In pl, this message translates to:
  /// **'• Zabrudzone opakowania'**
  String get dirtyPackaging;

  /// No description provided for @hygienicWaste.
  ///
  /// In pl, this message translates to:
  /// **'• Odpady higieniczne'**
  String get hygienicWaste;

  /// No description provided for @hazardousWaste.
  ///
  /// In pl, this message translates to:
  /// **'• Odpadów niebezpiecznych'**
  String get hazardousWaste;

  /// No description provided for @reminder.
  ///
  /// In pl, this message translates to:
  /// **'Przypomnienie'**
  String get reminder;

  /// No description provided for @notificationTime.
  ///
  /// In pl, this message translates to:
  /// **'Godzina powiadomień'**
  String get notificationTime;

  /// No description provided for @locationAccess.
  ///
  /// In pl, this message translates to:
  /// **'Dostęp do lokalizacji'**
  String get locationAccess;

  /// No description provided for @language.
  ///
  /// In pl, this message translates to:
  /// **'Język'**
  String get language;

  /// No description provided for @appVersion.
  ///
  /// In pl, this message translates to:
  /// **'Wersja aplikacji'**
  String get appVersion;

  /// No description provided for @copyright.
  ///
  /// In pl, this message translates to:
  /// **'Copyright'**
  String get copyright;

  /// No description provided for @testNotifications.
  ///
  /// In pl, this message translates to:
  /// **'Test powiadomień'**
  String get testNotifications;

  /// No description provided for @test.
  ///
  /// In pl, this message translates to:
  /// **'Test'**
  String get test;

  /// No description provided for @check.
  ///
  /// In pl, this message translates to:
  /// **'Sprawdź'**
  String get check;

  /// No description provided for @scheduledNotifications.
  ///
  /// In pl, this message translates to:
  /// **'Zaplanowane powiadomienia'**
  String get scheduledNotifications;

  /// No description provided for @testNotificationSent.
  ///
  /// In pl, this message translates to:
  /// **'Wysłano testowe powiadomienie'**
  String get testNotificationSent;

  /// No description provided for @enabled.
  ///
  /// In pl, this message translates to:
  /// **'Włączone'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In pl, this message translates to:
  /// **'Wyłączone'**
  String get disabled;

  /// No description provided for @polish.
  ///
  /// In pl, this message translates to:
  /// **'Polski'**
  String get polish;

  /// No description provided for @english.
  ///
  /// In pl, this message translates to:
  /// **'Angielski'**
  String get english;

  /// No description provided for @wasteReminder.
  ///
  /// In pl, this message translates to:
  /// **'Przypomnienie o odpadach'**
  String get wasteReminder;

  /// No description provided for @checkWasteScheduleToday.
  ///
  /// In pl, this message translates to:
  /// **'Sprawdź harmonogram odbioru odpadów na dzisiaj'**
  String get checkWasteScheduleToday;

  /// No description provided for @permissionsRequired.
  ///
  /// In pl, this message translates to:
  /// **'Uprawnienia wymagane'**
  String get permissionsRequired;

  /// No description provided for @permissionMessage.
  ///
  /// In pl, this message translates to:
  /// **'Aby korzystać z tej funkcji, musisz udzielić uprawnień do {permissionType} w ustawieniach aplikacji.'**
  String permissionMessage(String permissionType);

  /// No description provided for @openSettings.
  ///
  /// In pl, this message translates to:
  /// **'Otwórz ustawienia'**
  String get openSettings;

  /// No description provided for @monday.
  ///
  /// In pl, this message translates to:
  /// **'Poniedziałek'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In pl, this message translates to:
  /// **'Wtorek'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In pl, this message translates to:
  /// **'Środa'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In pl, this message translates to:
  /// **'Czwartek'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In pl, this message translates to:
  /// **'Piątek'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In pl, this message translates to:
  /// **'Sobota'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In pl, this message translates to:
  /// **'Niedziela'**
  String get sunday;

  /// No description provided for @january.
  ///
  /// In pl, this message translates to:
  /// **'Styczeń'**
  String get january;

  /// No description provided for @february.
  ///
  /// In pl, this message translates to:
  /// **'Luty'**
  String get february;

  /// No description provided for @march.
  ///
  /// In pl, this message translates to:
  /// **'Marzec'**
  String get march;

  /// No description provided for @april.
  ///
  /// In pl, this message translates to:
  /// **'Kwiecień'**
  String get april;

  /// No description provided for @may.
  ///
  /// In pl, this message translates to:
  /// **'Maj'**
  String get may;

  /// No description provided for @june.
  ///
  /// In pl, this message translates to:
  /// **'Czerwiec'**
  String get june;

  /// No description provided for @july.
  ///
  /// In pl, this message translates to:
  /// **'Lipiec'**
  String get july;

  /// No description provided for @august.
  ///
  /// In pl, this message translates to:
  /// **'Sierpień'**
  String get august;

  /// No description provided for @september.
  ///
  /// In pl, this message translates to:
  /// **'Wrzesień'**
  String get september;

  /// No description provided for @october.
  ///
  /// In pl, this message translates to:
  /// **'Październik'**
  String get october;

  /// No description provided for @november.
  ///
  /// In pl, this message translates to:
  /// **'Listopad'**
  String get november;

  /// No description provided for @december.
  ///
  /// In pl, this message translates to:
  /// **'Grudzień'**
  String get december;

  /// No description provided for @noInternetConnection.
  ///
  /// In pl, this message translates to:
  /// **'Brak połączenia z internetem. Sprawdź połączenie i spróbuj ponownie.'**
  String get noInternetConnection;

  /// No description provided for @serverError.
  ///
  /// In pl, this message translates to:
  /// **'Błąd serwera. Spróbuj ponownie później.'**
  String get serverError;

  /// No description provided for @unknownError.
  ///
  /// In pl, this message translates to:
  /// **'Nieoczekiwany błąd'**
  String get unknownError;

  /// No description provided for @loadingError.
  ///
  /// In pl, this message translates to:
  /// **'Błąd ładowania danych'**
  String get loadingError;

  /// No description provided for @tryAgainLater.
  ///
  /// In pl, this message translates to:
  /// **'Spróbuj ponownie później'**
  String get tryAgainLater;

  /// No description provided for @timeoutError.
  ///
  /// In pl, this message translates to:
  /// **'Przekroczono czas oczekiwania. Sprawdź połączenie internetowe.'**
  String get timeoutError;

  /// No description provided for @requestCancelled.
  ///
  /// In pl, this message translates to:
  /// **'Żądanie zostało anulowane.'**
  String get requestCancelled;

  /// No description provided for @scheduleNotFound.
  ///
  /// In pl, this message translates to:
  /// **'Nie znaleziono harmonogramu dla tego adresu.'**
  String get scheduleNotFound;

  /// No description provided for @fieldCannotBeEmpty.
  ///
  /// In pl, this message translates to:
  /// **'{fieldName} nie może być pusty'**
  String fieldCannotBeEmpty(String fieldName);

  /// No description provided for @fieldTooLong.
  ///
  /// In pl, this message translates to:
  /// **'{fieldName} jest zbyt długi (max {maxLength} znaków)'**
  String fieldTooLong(String fieldName, int maxLength);

  /// No description provided for @errorLoadingSchedule.
  ///
  /// In pl, this message translates to:
  /// **'Błąd pobierania harmonogramu'**
  String get errorLoadingSchedule;

  /// No description provided for @errorLoadingSectors.
  ///
  /// In pl, this message translates to:
  /// **'Błąd pobierania sektorów'**
  String get errorLoadingSectors;

  /// No description provided for @errorLoadingStreets.
  ///
  /// In pl, this message translates to:
  /// **'Błąd pobierania ulic'**
  String get errorLoadingStreets;

  /// No description provided for @errorLoadingProperties.
  ///
  /// In pl, this message translates to:
  /// **'Błąd pobierania posesji'**
  String get errorLoadingProperties;

  /// No description provided for @errorLoadingDetails.
  ///
  /// In pl, this message translates to:
  /// **'Błąd pobierania szczegółów'**
  String get errorLoadingDetails;

  /// No description provided for @errorSearchingWaste.
  ///
  /// In pl, this message translates to:
  /// **'Błąd wyszukiwania odpadów'**
  String get errorSearchingWaste;

  /// No description provided for @serverErrorCode.
  ///
  /// In pl, this message translates to:
  /// **'Błąd serwera: {code}'**
  String serverErrorCode(int code);

  /// No description provided for @scheduleTooltip.
  ///
  /// In pl, this message translates to:
  /// **'Harmonogram'**
  String get scheduleTooltip;

  /// No description provided for @knowledgeBaseTooltip.
  ///
  /// In pl, this message translates to:
  /// **'Baza wiedzy'**
  String get knowledgeBaseTooltip;

  /// No description provided for @shopTooltip.
  ///
  /// In pl, this message translates to:
  /// **'Sklep KOMA'**
  String get shopTooltip;

  /// No description provided for @bokTooltip.
  ///
  /// In pl, this message translates to:
  /// **'BOK Portal'**
  String get bokTooltip;

  /// No description provided for @notificationsTooltip.
  ///
  /// In pl, this message translates to:
  /// **'Powiadomienia'**
  String get notificationsTooltip;

  /// No description provided for @settingsTooltip.
  ///
  /// In pl, this message translates to:
  /// **'Ustawienia'**
  String get settingsTooltip;

  /// No description provided for @disposalLocations.
  ///
  /// In pl, this message translates to:
  /// **'Lokalizacje utylizacji'**
  String get disposalLocations;

  /// No description provided for @searchLocationPlaceholder.
  ///
  /// In pl, this message translates to:
  /// **'Wyszukaj lokalizację...'**
  String get searchLocationPlaceholder;

  /// No description provided for @all.
  ///
  /// In pl, this message translates to:
  /// **'Wszystkie'**
  String get all;

  /// No description provided for @loadingLocationsError.
  ///
  /// In pl, this message translates to:
  /// **'Błąd ładowania lokalizacji'**
  String get loadingLocationsError;

  /// No description provided for @noLocations.
  ///
  /// In pl, this message translates to:
  /// **'Brak lokalizacji'**
  String get noLocations;

  /// No description provided for @noLocationsForFilters.
  ///
  /// In pl, this message translates to:
  /// **'Nie znaleziono lokalizacji dla wybranych kryteriów'**
  String get noLocationsForFilters;

  /// No description provided for @map.
  ///
  /// In pl, this message translates to:
  /// **'Mapa'**
  String get map;

  /// No description provided for @call.
  ///
  /// In pl, this message translates to:
  /// **'Zadzwoń'**
  String get call;

  /// No description provided for @delete.
  ///
  /// In pl, this message translates to:
  /// **'Usuń'**
  String get delete;

  /// No description provided for @addressChangedTo.
  ///
  /// In pl, this message translates to:
  /// **'Zmieniono adres na'**
  String get addressChangedTo;

  /// No description provided for @externalLinks.
  ///
  /// In pl, this message translates to:
  /// **'Linki zewnętrzne'**
  String get externalLinks;

  /// No description provided for @pageNotFound.
  ///
  /// In pl, this message translates to:
  /// **'Nie znaleziono strony: {routeName}'**
  String pageNotFound(String routeName);

  /// No description provided for @returnToMain.
  ///
  /// In pl, this message translates to:
  /// **'Powrót do głównej'**
  String get returnToMain;

  /// No description provided for @appSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Zarządzanie odpadami'**
  String get appSubtitle;

  /// No description provided for @elektro.
  ///
  /// In pl, this message translates to:
  /// **'Elektro'**
  String get elektro;

  /// No description provided for @opony.
  ///
  /// In pl, this message translates to:
  /// **'Opony'**
  String get opony;

  /// No description provided for @computers.
  ///
  /// In pl, this message translates to:
  /// **'Komputery'**
  String get computers;

  /// No description provided for @phones.
  ///
  /// In pl, this message translates to:
  /// **'Telefony'**
  String get phones;

  /// No description provided for @televisions.
  ///
  /// In pl, this message translates to:
  /// **'Telewizory'**
  String get televisions;

  /// No description provided for @refrigerators.
  ///
  /// In pl, this message translates to:
  /// **'Lodówki'**
  String get refrigerators;

  /// No description provided for @carTires.
  ///
  /// In pl, this message translates to:
  /// **'Opony samochodowe'**
  String get carTires;

  /// No description provided for @bicycleTires.
  ///
  /// In pl, this message translates to:
  /// **'Opony rowerowe'**
  String get bicycleTires;

  /// No description provided for @motorcycleTires.
  ///
  /// In pl, this message translates to:
  /// **'Opony motocyklowe'**
  String get motorcycleTires;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pl', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
