// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Aplikacja KOMA';

  @override
  String get koma => 'KOMA';

  @override
  String get komaServices => 'KOMA USŁUGI KOMUNALNE';

  @override
  String get back => 'POWRÓT';

  @override
  String get returnButton => 'POWRÓT';

  @override
  String get cancel => 'Anuluj';

  @override
  String get ok => 'OK';

  @override
  String get search => 'Szukaj';

  @override
  String get loading => 'Ładowanie...';

  @override
  String get error => 'Błąd';

  @override
  String get noData => 'Brak danych';

  @override
  String get tryAgain => 'Spróbuj ponownie';

  @override
  String get schedule => 'Harmonogram';

  @override
  String get knowledgeBase => 'Baza wiedzy';

  @override
  String get shop => 'Sklep KOMA';

  @override
  String get bokPortal => 'BOK Portal';

  @override
  String get notifications => 'Powiadomienia';

  @override
  String get settings => 'Ustawienia';

  @override
  String get notificationsComingSoon => 'Powiadomienia - wkrótce dostępne';

  @override
  String get addressSearch => 'Wyszukiwanie adresu';

  @override
  String get searchAddress => 'WYSZUKAJ';

  @override
  String get address => 'ADRES';

  @override
  String get useLocation => 'Użyj lokalizacji';

  @override
  String get gettingLocation => 'Pobieranie lokalizacji...';

  @override
  String get locationError => 'Błąd lokalizacji';

  @override
  String get gpsLocation => 'Lokalizacja GPS';

  @override
  String get coordinates => 'Współrzędne';

  @override
  String get selectSector => 'Wybierz sektor';

  @override
  String get selectPrefix => 'Wybierz prefiks';

  @override
  String get selectLocality => 'Wybierz miejscowość';

  @override
  String get selectCity => 'Wybierz miasto';

  @override
  String get selectStreet => 'Wybierz ulicę';

  @override
  String get selectProperty => 'Wybierz posesję';

  @override
  String get selectPropertyNumber => 'Wybierz numer posesji';

  @override
  String get noProperties => 'Brak posesji - sprawdź logi';

  @override
  String get showSchedule => 'POKAŻ HARMONOGRAM';

  @override
  String get loadingSectors => 'Ładowanie sektorów...';

  @override
  String get loadingSectorsError => 'Błąd ładowania sektorów';

  @override
  String get selectSectorAndLocality => 'Wybierz sektor i miejscowość';

  @override
  String get toFindSchedule =>
      'Aby znaleźć harmonogram, wybierz adres z listy poniżej lub użyj wyszukiwania ręcznego.';

  @override
  String get favoriteLocations => 'Ulubione lokalizacje';

  @override
  String get recentLocations => 'Ostatnie lokalizacje';

  @override
  String get recentSearches => 'Ostatnie wyszukiwania';

  @override
  String get addedToFavorites => 'Dodano do ulubionych';

  @override
  String get removedFromFavorites => 'Usunięto z ulubionych';

  @override
  String get orSelectNewLocation =>
      'Lub wybierz nową lokalizację używając list rozwijanych powyżej';

  @override
  String get wasteSchedule => 'Harmonogram odpadów';

  @override
  String get wasteCollection => 'Odbiór odpadów';

  @override
  String get today => 'Dzisiaj';

  @override
  String get tomorrow => 'Jutro';

  @override
  String get nextWeek => 'W przyszłym tygodniu';

  @override
  String get wasteToday => 'Odpady na dzisiaj';

  @override
  String get todayCollection => 'Dzisiaj odbiera się: ';

  @override
  String get wasteType => 'Typ odpadu';

  @override
  String get collectionTime => 'Czas odbioru';

  @override
  String get container => 'Pojemnik';

  @override
  String get frequency => 'Częstotliwość';

  @override
  String get wasteDatabase => 'Baza Odpadów';

  @override
  String get searchWaste => 'WYSZUKAJ';

  @override
  String get waste => 'ODPADY';

  @override
  String get enterWasteName => 'Wpisz nazwę odpadu';

  @override
  String get searching => 'Wyszukiwanie...';

  @override
  String noResultsFor(String query) {
    return 'Brak odpadów zaczynających się na \"$query\"';
  }

  @override
  String get whereToThrow => 'Gdzie wyrzucić:';

  @override
  String get or => 'lub:';

  @override
  String get wasteGroup => 'Grupa odpadów:';

  @override
  String get searchAgain => 'Wyszukaj ponownie';

  @override
  String get checkWhereToThrow => 'Sprawdź gdzie wyrzucić';

  @override
  String get minThreeCharacters =>
      'Wpisz co najmniej 3 znaki, aby wyszukać odpady';

  @override
  String get howToSegregate => 'JAK SEGREGOWAĆ?';

  @override
  String get segregationGuide => 'Przewodnik segregacji';

  @override
  String get instructions => 'Instrukcje';

  @override
  String get whatCanBeThrown => 'Co można wyrzucić';

  @override
  String get whatCannotBeThrown => 'Czego nie można wyrzucić';

  @override
  String get preparation => 'Przygotowanie';

  @override
  String get notes => 'Uwagi';

  @override
  String get attention => 'Uwaga:';

  @override
  String get doNotThrow => 'Nie wrzucaj:';

  @override
  String get mixed => 'Zmieszane';

  @override
  String get paper => 'Papier';

  @override
  String get glass => 'Szkło';

  @override
  String get plastic => 'Metale i tworzywa sztuczne';

  @override
  String get bio => 'Bio';

  @override
  String get ash => 'Popiół';

  @override
  String get bulky => 'Gabaryty';

  @override
  String get green => 'Odpady zielone';

  @override
  String get newspapersAndMagazines => '• Gazety i czasopisma';

  @override
  String get cardboardAndPaperboard => '• Kartony i tektury';

  @override
  String get officePaper => '• Papier biurowy';

  @override
  String get booksWithoutCovers => '• Książki (bez okładek)';

  @override
  String get dirtyPaper => '• Papieru zabrudzonego';

  @override
  String get wallpaper => '• Tapet';

  @override
  String get waxedPaper => '• Papieru woskowanego';

  @override
  String get glassBottles => '• Butelki szklane';

  @override
  String get glassJars => '• Słoiki szklane';

  @override
  String get glassPackaging => '• Opakowania szklane';

  @override
  String get windowGlass => '• Szkła okiennego';

  @override
  String get mirrors => '• Luster';

  @override
  String get porcelain => '• Porcelany';

  @override
  String get aluminumCans => '• Puszki aluminiowe';

  @override
  String get steelCans => '• Puszki stalowe';

  @override
  String get plasticPackaging => '• Opakowania z tworzyw sztucznych';

  @override
  String get drinkCartons => '• Kartony po napojach';

  @override
  String get batteries => '• Baterii';

  @override
  String get electronics => '• Elektroniki';

  @override
  String get foodScraps => '• Resztki jedzenia';

  @override
  String get eggShells => '• Skorupki jaj';

  @override
  String get coffeeAndTeaGrounds => '• Fusy kawy i herbaty';

  @override
  String get vegetableAndFruitPeels => '• Obierki warzyw i owoców';

  @override
  String get meatAndFish => '• Mięsa i ryb';

  @override
  String get bones => '• Kości';

  @override
  String get oil => '• Oleju';

  @override
  String get furnaceAsh => '• Popiół z pieców';

  @override
  String get fireplaceAsh => '• Popiół z kominków';

  @override
  String get slag => '• Żużel';

  @override
  String get cigaretteAsh => '• Popiołu z papierosów';

  @override
  String get otherWaste => '• Innych odpadów';

  @override
  String get furniture => '• Meble';

  @override
  String get appliances => '• Sprzęt AGD';

  @override
  String get bicycles => '• Rowery';

  @override
  String get mattresses => '• Materace';

  @override
  String get callForCollection => '• Zgłoś odbiór telefonicznie';

  @override
  String get placeInFront => '• Ustaw przed posesją';

  @override
  String get grassClippings => '• Skoszona trawa';

  @override
  String get leaves => '• Liście';

  @override
  String get branches => '• Gałęzie';

  @override
  String get hedgeTrimmings => '• Przycięte żywopłoty';

  @override
  String get plantWaste => '• Odpady roślinne';

  @override
  String get doNotThrowGreen => '• Nie wrzucaj:';

  @override
  String get soilAndStones => '• Ziemia i kamienie';

  @override
  String get foodWaste => '• Odpady spożywcze';

  @override
  String get nonRecyclableWaste =>
      '• Odpady, które nie nadają się do segregacji';

  @override
  String get dirtyPackaging => '• Zabrudzone opakowania';

  @override
  String get hygienicWaste => '• Odpady higieniczne';

  @override
  String get hazardousWaste => '• Odpadów niebezpiecznych';

  @override
  String get reminder => 'Przypomnienie';

  @override
  String get notificationTime => 'Godzina powiadomień';

  @override
  String get locationAccess => 'Dostęp do lokalizacji';

  @override
  String get language => 'Język';

  @override
  String get appVersion => 'Wersja aplikacji';

  @override
  String get copyright => 'Copyright';

  @override
  String get testNotifications => 'Test powiadomień';

  @override
  String get test => 'Test';

  @override
  String get check => 'Sprawdź';

  @override
  String get scheduledNotifications => 'Zaplanowane powiadomienia';

  @override
  String get testNotificationSent => 'Wysłano testowe powiadomienie';

  @override
  String get enabled => 'Włączone';

  @override
  String get disabled => 'Wyłączone';

  @override
  String get polish => 'Polski';

  @override
  String get english => 'Angielski';

  @override
  String get wasteReminder => 'Przypomnienie o odpadach';

  @override
  String get checkWasteScheduleToday =>
      'Sprawdź harmonogram odbioru odpadów na dzisiaj';

  @override
  String get permissionsRequired => 'Uprawnienia wymagane';

  @override
  String permissionMessage(String permissionType) {
    return 'Aby korzystać z tej funkcji, musisz udzielić uprawnień do $permissionType w ustawieniach aplikacji.';
  }

  @override
  String get openSettings => 'Otwórz ustawienia';

  @override
  String get monday => 'Poniedziałek';

  @override
  String get tuesday => 'Wtorek';

  @override
  String get wednesday => 'Środa';

  @override
  String get thursday => 'Czwartek';

  @override
  String get friday => 'Piątek';

  @override
  String get saturday => 'Sobota';

  @override
  String get sunday => 'Niedziela';

  @override
  String get january => 'Styczeń';

  @override
  String get february => 'Luty';

  @override
  String get march => 'Marzec';

  @override
  String get april => 'Kwiecień';

  @override
  String get may => 'Maj';

  @override
  String get june => 'Czerwiec';

  @override
  String get july => 'Lipiec';

  @override
  String get august => 'Sierpień';

  @override
  String get september => 'Wrzesień';

  @override
  String get october => 'Październik';

  @override
  String get november => 'Listopad';

  @override
  String get december => 'Grudzień';

  @override
  String get noInternetConnection =>
      'Brak połączenia z internetem. Sprawdź połączenie i spróbuj ponownie.';

  @override
  String get serverError => 'Błąd serwera. Spróbuj ponownie później.';

  @override
  String get unknownError => 'Nieoczekiwany błąd';

  @override
  String get loadingError => 'Błąd ładowania danych';

  @override
  String get tryAgainLater => 'Spróbuj ponownie później';

  @override
  String get timeoutError =>
      'Przekroczono czas oczekiwania. Sprawdź połączenie internetowe.';

  @override
  String get requestCancelled => 'Żądanie zostało anulowane.';

  @override
  String get scheduleNotFound => 'Nie znaleziono harmonogramu dla tego adresu.';

  @override
  String fieldCannotBeEmpty(String fieldName) {
    return '$fieldName nie może być pusty';
  }

  @override
  String fieldTooLong(String fieldName, int maxLength) {
    return '$fieldName jest zbyt długi (max $maxLength znaków)';
  }

  @override
  String get errorLoadingSchedule => 'Błąd pobierania harmonogramu';

  @override
  String get errorLoadingSectors => 'Błąd pobierania sektorów';

  @override
  String get errorLoadingStreets => 'Błąd pobierania ulic';

  @override
  String get errorLoadingProperties => 'Błąd pobierania posesji';

  @override
  String get errorLoadingDetails => 'Błąd pobierania szczegółów';

  @override
  String get errorSearchingWaste => 'Błąd wyszukiwania odpadów';

  @override
  String serverErrorCode(int code) {
    return 'Błąd serwera: $code';
  }

  @override
  String get scheduleTooltip => 'Harmonogram';

  @override
  String get knowledgeBaseTooltip => 'Baza wiedzy';

  @override
  String get shopTooltip => 'Sklep KOMA';

  @override
  String get bokTooltip => 'BOK Portal';

  @override
  String get notificationsTooltip => 'Powiadomienia';

  @override
  String get settingsTooltip => 'Ustawienia';

  @override
  String get disposalLocations => 'Lokalizacje utylizacji';

  @override
  String get searchLocationPlaceholder => 'Wyszukaj lokalizację...';

  @override
  String get all => 'Wszystkie';

  @override
  String get loadingLocationsError => 'Błąd ładowania lokalizacji';

  @override
  String get noLocations => 'Brak lokalizacji';

  @override
  String get noLocationsForFilters =>
      'Nie znaleziono lokalizacji dla wybranych kryteriów';

  @override
  String get map => 'Mapa';

  @override
  String get call => 'Zadzwoń';

  @override
  String get delete => 'Usuń';

  @override
  String get addressChangedTo => 'Zmieniono adres na';

  @override
  String get externalLinks => 'Linki zewnętrzne';

  @override
  String pageNotFound(String routeName) {
    return 'Nie znaleziono strony: $routeName';
  }

  @override
  String get returnToMain => 'Powrót do głównej';

  @override
  String get appSubtitle => 'Zarządzanie odpadami';

  @override
  String get elektro => 'Elektro';

  @override
  String get opony => 'Opony';

  @override
  String get computers => 'Komputery';

  @override
  String get phones => 'Telefony';

  @override
  String get televisions => 'Telewizory';

  @override
  String get refrigerators => 'Lodówki';

  @override
  String get carTires => 'Opony samochodowe';

  @override
  String get bicycleTires => 'Opony rowerowe';

  @override
  String get motorcycleTires => 'Opony motocyklowe';
}
