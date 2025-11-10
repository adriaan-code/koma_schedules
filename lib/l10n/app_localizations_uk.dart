// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Додаток KOMA';

  @override
  String get koma => 'KOMA';

  @override
  String get komaServices => 'KOMA КОМУНАЛЬНІ ПОСЛУГИ';

  @override
  String get back => 'НАЗАД';

  @override
  String get returnButton => 'НАЗАД';

  @override
  String get cancel => 'Скасувати';

  @override
  String get ok => 'OK';

  @override
  String get search => 'Пошук';

  @override
  String get loading => 'Завантаження...';

  @override
  String get error => 'Помилка';

  @override
  String get noData => 'Немає даних';

  @override
  String get tryAgain => 'Спробуйте знову';

  @override
  String get schedule => 'Розклад';

  @override
  String get knowledgeBase => 'База знань';

  @override
  String get shop => 'Магазин KOMA';

  @override
  String get bokPortal => 'BOK Портал';

  @override
  String get notifications => 'Сповіщення';

  @override
  String get settings => 'Налаштування';

  @override
  String get notificationsComingSoon => 'Сповіщення - скоро доступні';

  @override
  String get addressSearch => 'Пошук адреси';

  @override
  String get searchAddress => 'ШУКАТИ';

  @override
  String get address => 'АДРЕСА';

  @override
  String get useLocation => 'Використати локацію';

  @override
  String get gettingLocation => 'Отримання локації...';

  @override
  String get locationError => 'Помилка локації';

  @override
  String get gpsLocation => 'GPS локація';

  @override
  String get coordinates => 'Координати';

  @override
  String get selectSector => 'Виберіть сектор';

  @override
  String get selectPrefix => 'Виберіть префікс';

  @override
  String get selectLocality => 'Виберіть населений пункт';

  @override
  String get selectCity => 'Виберіть місто';

  @override
  String get selectStreet => 'Виберіть вулицю';

  @override
  String get selectProperty => 'Виберіть нерухомість';

  @override
  String get selectPropertyNumber => 'Виберіть номер будинку';

  @override
  String get noProperties => 'Немає нерухомості - перевірте журнали';

  @override
  String get showSchedule => 'ПОКАЗАТИ РОЗКЛАД';

  @override
  String get loadingSectors => 'Завантаження секторів...';

  @override
  String get loadingSectorsError => 'Помилка завантаження секторів';

  @override
  String get selectSectorAndLocality => 'Виберіть сектор та населений пункт';

  @override
  String get toFindSchedule =>
      'Щоб знайти розклад, виберіть адресу зі списку нижче або використовуйте ручний пошук.';

  @override
  String get favoriteLocations => 'Улюблені локації';

  @override
  String get recentLocations => 'Останні локації';

  @override
  String get recentSearches => 'Останні пошуки';

  @override
  String get addedToFavorites => 'Додано до улюблених';

  @override
  String get removedFromFavorites => 'Видалено з улюблених';

  @override
  String get orSelectNewLocation =>
      'Або виберіть нову локацію, використовуючи списки вище';

  @override
  String get wasteSchedule => 'Розклад відходів';

  @override
  String get wasteCollection => 'Вивезення відходів';

  @override
  String get today => 'Сьогодні';

  @override
  String get tomorrow => 'Завтра';

  @override
  String get nextWeek => 'Наступного тижня';

  @override
  String get wasteToday => 'Відходи сьогодні';

  @override
  String get todayCollection => 'Сьогодні вивозять: ';

  @override
  String get wasteType => 'Тип відходів';

  @override
  String get collectionTime => 'Час вивезення';

  @override
  String get container => 'Контейнер';

  @override
  String get frequency => 'Частота';

  @override
  String get wasteDatabase => 'База відходів';

  @override
  String get searchWaste => 'ШУКАТИ';

  @override
  String get waste => 'ВІДХОДИ';

  @override
  String get enterWasteName => 'Введіть назву відходів';

  @override
  String get searching => 'Пошук...';

  @override
  String noResultsFor(String query) {
    return 'Немає відходів, що починаються з \"$query\"';
  }

  @override
  String get whereToThrow => 'Куди викинути:';

  @override
  String get or => 'або:';

  @override
  String get wasteGroup => 'Група відходів:';

  @override
  String get searchAgain => 'Шукати знову';

  @override
  String get checkWhereToThrow => 'Перевірте, куди викинути';

  @override
  String get minThreeCharacters =>
      'Введіть принаймні 3 символи для пошуку відходів';

  @override
  String get howToSegregate => 'ЯК СОРТУВАТИ?';

  @override
  String get segregationGuide => 'Посібник із сортування';

  @override
  String get instructions => 'Інструкції';

  @override
  String get whatCanBeThrown => 'Що можна викинути';

  @override
  String get whatCannotBeThrown => 'Що не можна викинути';

  @override
  String get preparation => 'Підготовка';

  @override
  String get notes => 'Примітки';

  @override
  String get attention => 'Увага:';

  @override
  String get doNotThrow => 'Не викидайте:';

  @override
  String get mixed => 'Змішані';

  @override
  String get paper => 'Папір';

  @override
  String get glass => 'Скло';

  @override
  String get plastic => 'Метали та пластик';

  @override
  String get bio => 'Біо';

  @override
  String get ash => 'Попіл';

  @override
  String get bulky => 'Габаритні';

  @override
  String get green => 'Зелені відходи';

  @override
  String get newspapersAndMagazines => '• Газети та журнали';

  @override
  String get cardboardAndPaperboard => '• Картон';

  @override
  String get officePaper => '• Офісний папір';

  @override
  String get booksWithoutCovers => '• Книги (без обкладинок)';

  @override
  String get dirtyPaper => '• Забрудненого паперу';

  @override
  String get wallpaper => '• Шпалер';

  @override
  String get waxedPaper => '• Вощеного паперу';

  @override
  String get glassBottles => '• Скляні пляшки';

  @override
  String get glassJars => '• Скляні банки';

  @override
  String get glassPackaging => '• Скляна упаковка';

  @override
  String get windowGlass => '• Віконного скла';

  @override
  String get mirrors => '• Дзеркал';

  @override
  String get porcelain => '• Порцеляни';

  @override
  String get aluminumCans => '• Алюмінієві банки';

  @override
  String get steelCans => '• Сталеві банки';

  @override
  String get plasticPackaging => '• Пластикова упаковка';

  @override
  String get drinkCartons => '• Картонні пакети з напоями';

  @override
  String get batteries => '• Батарейок';

  @override
  String get electronics => '• Електроніки';

  @override
  String get foodScraps => '• Харчові залишки';

  @override
  String get eggShells => '• Яєчна шкаралупа';

  @override
  String get coffeeAndTeaGrounds => '• Кавова та чайна гуща';

  @override
  String get vegetableAndFruitPeels => '• Очистки овочів та фруктів';

  @override
  String get meatAndFish => '• М\'яса та риби';

  @override
  String get bones => '• Кісток';

  @override
  String get oil => '• Олії';

  @override
  String get furnaceAsh => '• Попіл із печей';

  @override
  String get fireplaceAsh => '• Попіл із камінів';

  @override
  String get slag => '• Шлак';

  @override
  String get cigaretteAsh => '• Попіл від сигарет';

  @override
  String get otherWaste => '• Інших відходів';

  @override
  String get furniture => '• Меблі';

  @override
  String get appliances => '• Побутова техніка';

  @override
  String get bicycles => '• Велосипеди';

  @override
  String get mattresses => '• Матраци';

  @override
  String get callForCollection => '• Замовте вивезення телефоном';

  @override
  String get placeInFront => '• Виставте перед будинком';

  @override
  String get grassClippings => '• Скошена трава';

  @override
  String get leaves => '• Листя';

  @override
  String get branches => '• Гілки';

  @override
  String get hedgeTrimmings => '• Обрізані живоплоти';

  @override
  String get plantWaste => '• Рослинні відходи';

  @override
  String get doNotThrowGreen => '• Не викидайте:';

  @override
  String get soilAndStones => '• Земля та каміння';

  @override
  String get foodWaste => '• Харчові відходи';

  @override
  String get nonRecyclableWaste => '• Відходи, що не підлягають переробці';

  @override
  String get dirtyPackaging => '• Забруднена упаковка';

  @override
  String get hygienicWaste => '• Гігієнічні відходи';

  @override
  String get hazardousWaste => '• Небезпечних відходів';

  @override
  String get reminder => 'Нагадування';

  @override
  String get notificationTime => 'Час сповіщень';

  @override
  String get locationAccess => 'Доступ до локації';

  @override
  String get language => 'Мова';

  @override
  String get appVersion => 'Версія додатку';

  @override
  String get copyright => 'Copyright';

  @override
  String get testNotifications => 'Тест сповіщень';

  @override
  String get test => 'Тест';

  @override
  String get check => 'Перевірити';

  @override
  String get scheduledNotifications => 'Заплановані сповіщення';

  @override
  String get testNotificationSent => 'Тестове сповіщення надіслано';

  @override
  String get enabled => 'Увімкнено';

  @override
  String get disabled => 'Вимкнено';

  @override
  String get polish => 'Польська';

  @override
  String get english => 'Англійська';

  @override
  String get wasteReminder => 'Нагадування про відходи';

  @override
  String get checkWasteScheduleToday =>
      'Перевірте розклад вивезення відходів на сьогодні';

  @override
  String get permissionsRequired => 'Потрібні дозволи';

  @override
  String permissionMessage(String permissionType) {
    return 'Щоб використовувати цю функцію, потрібно надати дозволи на $permissionType в налаштуваннях додатку.';
  }

  @override
  String get openSettings => 'Відкрити налаштування';

  @override
  String get monday => 'Понеділок';

  @override
  String get tuesday => 'Вівторок';

  @override
  String get wednesday => 'Середа';

  @override
  String get thursday => 'Четвер';

  @override
  String get friday => 'П\'ятниця';

  @override
  String get saturday => 'Субота';

  @override
  String get sunday => 'Неділя';

  @override
  String get january => 'Січень';

  @override
  String get february => 'Лютий';

  @override
  String get march => 'Березень';

  @override
  String get april => 'Квітень';

  @override
  String get may => 'Травень';

  @override
  String get june => 'Червень';

  @override
  String get july => 'Липень';

  @override
  String get august => 'Серпень';

  @override
  String get september => 'Вересень';

  @override
  String get october => 'Жовтень';

  @override
  String get november => 'Листопад';

  @override
  String get december => 'Грудень';

  @override
  String get noInternetConnection =>
      'Немає підключення до інтернету. Перевірте підключення та спробуйте знову.';

  @override
  String get serverError => 'Помилка сервера. Спробуйте пізніше.';

  @override
  String get unknownError => 'Неочікувана помилка';

  @override
  String get loadingError => 'Помилка завантаження даних';

  @override
  String get tryAgainLater => 'Спробуйте пізніше';

  @override
  String get timeoutError =>
      'Перевищено час очікування. Перевірте інтернет-з\'єднання.';

  @override
  String get requestCancelled => 'Запит було скасовано.';

  @override
  String get scheduleNotFound => 'Не знайдено розклад для цієї адреси.';

  @override
  String fieldCannotBeEmpty(String fieldName) {
    return '$fieldName не може бути порожнім';
  }

  @override
  String fieldTooLong(String fieldName, int maxLength) {
    return '$fieldName занадто довгий (макс. $maxLength символів)';
  }

  @override
  String get errorLoadingSchedule => 'Помилка завантаження розкладу';

  @override
  String get errorLoadingSectors => 'Помилка завантаження секторів';

  @override
  String get errorLoadingStreets => 'Помилка завантаження вулиць';

  @override
  String get errorLoadingProperties => 'Помилка завантаження нерухомості';

  @override
  String get errorLoadingDetails => 'Помилка завантаження деталей';

  @override
  String get errorSearchingWaste => 'Помилка пошуку відходів';

  @override
  String serverErrorCode(int code) {
    return 'Помилка сервера: $code';
  }

  @override
  String get scheduleTooltip => 'Розклад';

  @override
  String get knowledgeBaseTooltip => 'База знань';

  @override
  String get shopTooltip => 'Магазин KOMA';

  @override
  String get bokTooltip => 'BOK Портал';

  @override
  String get notificationsTooltip => 'Сповіщення';

  @override
  String get settingsTooltip => 'Налаштування';

  @override
  String get disposalLocations => 'Пункти утилізації';

  @override
  String get searchLocationPlaceholder => 'Пошук локації...';

  @override
  String get all => 'Усі';

  @override
  String get loadingLocationsError => 'Помилка завантаження локацій';

  @override
  String get noLocations => 'Немає локацій';

  @override
  String get noLocationsForFilters =>
      'Не знайдено локацій за обраними фільтрами';

  @override
  String get map => 'Карта';

  @override
  String get call => 'Зателефонувати';

  @override
  String get delete => 'Видалити';

  @override
  String get addressChangedTo => 'Адресу змінено на';

  @override
  String get externalLinks => 'Зовнішні посилання';

  @override
  String pageNotFound(String routeName) {
    return 'Не знайдено сторінку: $routeName';
  }

  @override
  String get returnToMain => 'Повернутися на головну';

  @override
  String get appSubtitle => 'Управління відходами';

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
