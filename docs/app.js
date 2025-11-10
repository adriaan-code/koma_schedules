(function(){
  const links = Array.from(document.querySelectorAll('.nav a'));
  const sections = links.map(a => document.querySelector(a.getAttribute('href'))).filter(Boolean);
  const select = document.getElementById('langSelect');
  const i18nNodes = Array.from(document.querySelectorAll('[data-i18n]'));
  const main = document.getElementById('content');

  function onScroll(){
    const y = (main ? main.scrollTop : window.scrollY) + 100;
    let activeIdx = 0;
    sections.forEach((sec, i) => {
      if(sec.offsetTop <= y) activeIdx = i;
    });
    links.forEach((a, i) => a.classList.toggle('active', i === activeIdx));
  }

  function smoothNav(e){
    if(e.target.tagName.toLowerCase() !== 'a') return;
    const href = e.target.getAttribute('href');
    if(!href || !href.startsWith('#')) return;
    e.preventDefault();
    const target = document.querySelector(href);
    if(target){
      const container = main || window;
      const top = target.offsetTop - 12; // small offset for padding
      if(main){
        main.scrollTo({ top, behavior: 'smooth' });
      } else {
        window.scrollTo({ top, behavior: 'smooth' });
      }
      history.replaceState(null, '', href);
    }
  }

  // Simple client-side filter
  const input = document.getElementById('searchInput');
  function search(){
    const q = (input.value || '').toLowerCase();
    sections.forEach(sec => {
      const text = sec.textContent.toLowerCase();
      sec.style.display = text.includes(q) ? '' : 'none';
    });
  }

  // i18n dictionaries (PL default)
  const dict = {
    pl: {
      // Alerts
      'alert.notifWarning':'Uwaga: Na Androidzie tryb przybliżony może mieć kilkuminutowe odchylenie od ustawionej godziny.',
      'alert.securityInfo':'Informacja: Aplikacja nie przechowuje żadnych haseł ani kluczy tajnych w repozytorium.',
      'alert.apiError':'Błąd: W przypadku odpowiedzi 4xx/5xx aplikacja wyświetla komunikat i zapisuje log w konsoli.',
      // Lists content
      'sec.https':'HTTPS dla API; brak wrażliwych sekretów w repozytorium.',
      'sec.localData':'Dane lokalne: preferencje i historia adresów w <code>SharedPreferences</code>.',
      'sec.perms':'Uprawnienia ograniczone do minimum: powiadomienia (+ exact alarm na Androidzie jeśli dostępne).',
      'perf.lazy':'Listy budowane leniwie, bez zbędnych rebuildów.',
      'perf.filter':'Optymalizacja filtrowania harmonogramu po miesiącach i dniach.',
      'perf.async':'Brak ciężkich operacji na głównym wątku; I/O asynchroniczne.',
      'err.global':'Globalne <code>FlutterError.onError</code> i <code>PlatformDispatcher.onError</code>.',
      'err.dio':'Dio: mapowanie i komunikaty błędów (np. 400/500), fallbacki UI.',
      'err.notif':'Powiadomienia: rozbudowane logi, diagnostyka uprawnień.',
      'code.small':'Małe komponenty, czytelne nazwy, brak głębokiego zagnieżdżania.',
      'code.theme':'Wspólne style w <code>AppTheme</code>; modularny podział katalogów.',
      'code.comments':'Komentarze tylko tam, gdzie krytycznie potrzebne.',
      'contrib.branch':'Utwórz branch od <em>main</em>.',
      'contrib.ci':'Zapewnij przejście <code>flutter analyze</code> i testów.',
      'contrib.pr':'Wyślij PR z opisem zakresu i wpływu na UI/API.',
      'release.semver':'SemVer; zmiany UI/UX i tłumaczeń rejestrowane w <em>Zakres zmian</em>.',
      'release.platforms':'iOS: CocoaPods; Android: Android SDK.',
      'env.dev':'Dev: debug, bogate logi.',
      'env.prod':'Prod: release, zredukowane logi.',
      'cfg.api':'<code>config/api_config.dart</code> — domyślne godziny, endpointy.',
      'cfg.l10n':'<code>l10n.yaml</code> — konfiguracja generatora lokalizacji.',
      'ux.clarity':'Przejrzystość, kontrast, konsekwencja komponentów.',
      'ux.nav':'Dolna nawigacja: spójne stany i brak „białego paska”.',
      'l10n.arb':'Wszystkie teksty w <code>.arb</code>; użycie <code>AppLocalizations</code>.',
      'l10n.utils':'Miesiące/dni: <code>date_utils.dart</code>; frakcje: <code>waste_type_utils.dart</code>.',
      'dm.wasteType':'<strong>WasteType</strong>: <em>mixed, paper, glass, metal, bio, ash, bulky, green, elektro, opony</em>.',
      'dm.collection':'<strong>WasteCollection</strong>: <em>day, month, dayOfWeek, wasteType, originalTypeName</em>.',
      'dm.address':'<strong>Address</strong>: <em>prefix, propertyNumber, fullAddress</em>.',
      'state.local':'<code>StatefulWidget</code> + <code>setState</code> (prosty, przewidywalny model).',
      'state.prefs':'Preferencje: <code>SettingsService</code> (SharedPreferences).',
      'log.notif':'Logi debug w powiadomieniach: inicjalizacja, uprawnienia, planowanie.',
      'log.schedule':'Logi w harmonogramie: rozmiary list, bieżący miesiąc, elementy krańcowe.',
      title: 'KOMA App — Dokumentacja',
      'nav.security':'Bezpieczeństwo','nav.performance':'Wydajność','nav.errorHandling':'Obsługa błędów','nav.codingStandards':'Standardy kodowania','nav.contribution':'Wkład/kontrybucje','nav.release':'Wydania i wersje','nav.environments':'Środowiska','nav.configuration':'Konfiguracja','nav.ux':'Wytyczne UX','nav.l10n':'Wytyczne lokalizacji','nav.notificationMatrix':'Macierz powiadomień','nav.apiRef':'API Reference','nav.dataModels':'Modele danych (szczegóły)','nav.state':'Zarządzanie stanem','nav.logging':'Logowanie/Monitoring',
      'sec.heading':'Bezpieczeństwo',
      'perf.heading':'Wydajność',
      'err.heading':'Obsługa błędów',
      'code.heading':'Standardy kodowania',
      'contrib.heading':'Wkład/kontrybucje',
      'release.heading':'Wydania i wersje',
      'env.heading':'Środowiska',
      'cfg.heading':'Konfiguracja',
      'ux.heading':'Wytyczne UX',
      'l10n.heading':'Wytyczne lokalizacji',
      'nm.heading':'Macierz powiadomień','nm.platform':'Platforma','nm.mode':'Tryb','nm.perms':'Uprawnienia','nm.desc':'Opis','nm.exact':'Dokładny','nm.exactDesc':'Co do minuty (gdy system pozwala)','nm.approx':'Przybliżony','nm.approxDesc':'Tolerancja kilku minut','nm.standard':'Standard','nm.iosDesc':'Natywne dialogi, logi diagnostyczne',
      'api.heading':'API Reference','api.schedule':'Harmonogram','api.endpoint':'Endpoint','api.method':'Metoda','api.params':'Parametry','api.response':'Odpowiedź','api.map':'Mapowanie na <code>WasteType</code> w <code>ApiService</code> i <code>WasteTypeUtils</code>.',
      'dm.heading':'Modele danych (szczegóły)',
      'state.heading':'Zarządzanie stanem',
      'log.heading':'Logowanie/Monitoring',
      'nav.overview': 'Przegląd',
      'nav.gettingStarted': 'Uruchomienie',
      'nav.architecture': 'Architektura',
      'nav.localization': 'Lokalizacja (l10n)',
      'nav.notifications': 'Powiadomienia',
      'nav.api': 'Integracja z API',
      'nav.navigation': 'Nawigacja i Navbar',
      'nav.screens': 'Ekrany',
      'nav.advanced': 'Zaawansowane użycie',
      'nav.services': 'Serwisy',
      'nav.models': 'Modele',
      'nav.theming': 'Motyw i UI',
      'nav.accessibility': 'Dostępność',
      'nav.testing': 'Testy i analiza',
      'nav.troubleshooting': 'Rozwiązywanie problemów',
      'nav.limitations': 'Znane ograniczenia',
      'nav.roadmap': 'Roadmap',
      'nav.glossary': 'Słowniczek',
      'nav.versioning': 'Wersjonowanie',
      'nav.changelog': 'Zakres zmian',
      'nav.links': 'Linki',
      'hero.heading': 'Witaj w dokumentacji KOMA App',
      'hero.lead': 'Ta dokumentacja jest przeznaczona zarówno dla użytkowników aplikacji (jak korzystać), jak i dla zespołu technicznego (jak rozwijać i utrzymywać).',
      'hero.cta': 'Przejdź do instrukcji użytkownika',
      'user.heading': 'Instrukcja dla użytkownika',
      'user.start': 'Jak zacząć',
      'user.step1': 'Otwórz aplikację — pojawi się ekran powitalny i następnie główny ekran z dolną nawigacją.',
      'user.step2': 'Wybierz adres: przejdź do zakładki Harmonogram (ikona po lewej). Jeśli to pierwsze użycie, zobaczysz wyszukiwarkę adresów.',
      'user.step3': 'Wpisz ulicę i numer, wybierz propozycję z listy. Aplikacja zapisze ten adres do historii i załaduje harmonogram.',
      'user.schedule': 'Harmonogram odbiorów',
      'user.schedule1': 'Na liście znajdziesz daty i nazwy frakcji. Nazwy i miesiące są tłumaczone automatycznie do wybranego języka.',
      'user.schedule2': 'Kliknij pozycję, aby otworzyć Szczegóły frakcji — zobaczysz opis i wskazówki co wyrzucać, a czego nie.',
      'user.notifications': 'Powiadomienia',
      'user.notif1': 'Wejdź w Ustawienia (ikona koła zębatego po prawej).',
      'user.notif2': 'Włącz przełącznik Powiadomienia, a następnie wybierz Godzinę powiadomień.',
      'user.notif3': 'Możesz wysłać Test powiadomień, aby upewnić się, że urządzenie wyświetla je poprawnie.',
      'user.language': 'Zmiana języka',
      'user.lang1': 'W Ustawieniach rozwiń sekcję Język i wybierz: Polski, English lub Українська.',
      'user.lang2': 'Aplikacja natychmiast przełączy się na wybrany język.',
      'user.links': 'Linki zewnętrzne',
      'user.links1': 'W dolnej nawigacji środkowa ikona otwiera listę linków: BOK oraz Sklep KOMA.',
      'user.links2': 'Po wyborze nastąpi otwarcie przeglądarki z właściwą stroną.',
      'user.tip': 'Wskazówka: jeśli nie widzisz żadnych pozycji w harmonogramie, sprawdź czy wybrany adres został poprawnie zapisany oraz czy data nie była już w przeszłości. W grudniu widoczne są wszystkie miesiące.'
    },
    en: {
      // Alerts
      'alert.notifWarning':'Warning: On Android, approximate mode may drift by a few minutes from the selected time.',
      'alert.securityInfo':'Info: The app does not store any passwords or secret keys in the repository.',
      'alert.apiError':'Error: On 4xx/5xx responses the app shows a message and logs details to console.',
      // Lists content
      'sec.https':'HTTPS for API; no sensitive secrets in the repository.',
      'sec.localData':'Local data: preferences and address history in <code>SharedPreferences</code>.',
      'sec.perms':'Minimal permissions: notifications (+ exact alarm on Android when available).',
      'perf.lazy':'Lists are built lazily, avoiding unnecessary rebuilds.',
      'perf.filter':'Optimized schedule filtering by months and days.',
      'perf.async':'No heavy work on the main thread; async I/O.',
      'err.global':'Global <code>FlutterError.onError</code> and <code>PlatformDispatcher.onError</code>.',
      'err.dio':'Dio: error mapping and messages (e.g., 400/500), UI fallbacks.',
      'err.notif':'Notifications: extensive logs and permission diagnostics.',
      'code.small':'Small components, clear names, avoid deep nesting.',
      'code.theme':'Shared styles in <code>AppTheme</code>; modular folders.',
      'code.comments':'Comments only where critically needed.',
      'contrib.branch':'Create a branch from <em>main</em>.',
      'contrib.ci':'Ensure <code>flutter analyze</code> and tests pass.',
      'contrib.pr':'Open a PR with scope and UI/API impact.',
      'release.semver':'SemVer; UI/UX and translation changes recorded in <em>Changes</em>.',
      'release.platforms':'iOS: CocoaPods; Android: Android SDK.',
      'env.dev':'Dev: debug, rich logs.',
      'env.prod':'Prod: release, reduced logs.',
      'cfg.api':'<code>config/api_config.dart</code> — default hours, endpoints.',
      'cfg.l10n':'<code>l10n.yaml</code> — localization generator config.',
      'ux.clarity':'Clarity, contrast, component consistency.',
      'ux.nav':'Bottom nav: consistent states, no “white bar”.',
      'l10n.arb':'All texts in <code>.arb</code>; use <code>AppLocalizations</code>.',
      'l10n.utils':'Months/days: <code>date_utils.dart</code>; fractions: <code>waste_type_utils.dart</code>.',
      'dm.wasteType':'<strong>WasteType</strong>: <em>mixed, paper, glass, metal, bio, ash, bulky, green, elektro, opony</em>.',
      'dm.collection':'<strong>WasteCollection</strong>: <em>day, month, dayOfWeek, wasteType, originalTypeName</em>.',
      'dm.address':'<strong>Address</strong>: <em>prefix, propertyNumber, fullAddress</em>.',
      'state.local':'<code>StatefulWidget</code> + <code>setState</code> (simple, predictable).',
      'state.prefs':'Preferences: <code>SettingsService</code> (SharedPreferences).',
      'log.notif':'Debug logs in notifications: init, permissions, scheduling.',
      'log.schedule':'Schedule logs: list sizes, current month, edge items.',
      title: 'KOMA App — Documentation',
      'nav.security':'Security','nav.performance':'Performance','nav.errorHandling':'Error handling','nav.codingStandards':'Coding standards','nav.contribution':'Contribution','nav.release':'Release & versions','nav.environments':'Environments','nav.configuration':'Configuration','nav.ux':'UX guidelines','nav.l10n':'Localization guidelines','nav.notificationMatrix':'Notification matrix','nav.apiRef':'API Reference','nav.dataModels':'Data models (details)','nav.state':'State management','nav.logging':'Logging/Monitoring',
      'sec.heading':'Security',
      'perf.heading':'Performance',
      'err.heading':'Error handling',
      'code.heading':'Coding standards',
      'contrib.heading':'Contribution',
      'release.heading':'Release & versions',
      'env.heading':'Environments',
      'cfg.heading':'Configuration',
      'ux.heading':'UX guidelines',
      'l10n.heading':'Localization guidelines',
      'nm.heading':'Notification matrix','nm.platform':'Platform','nm.mode':'Mode','nm.perms':'Permissions','nm.desc':'Description','nm.exact':'Exact','nm.exactDesc':'Minute-precise (when allowed by the system)','nm.approx':'Approximate','nm.approxDesc':'Tolerance of a few minutes','nm.standard':'Standard','nm.iosDesc':'Native dialogs, diagnostic logs',
      'api.heading':'API Reference','api.schedule':'Schedule','api.endpoint':'Endpoint','api.method':'Method','api.params':'Params','api.response':'Response','api.map':'Mapping to <code>WasteType</code> in <code>ApiService</code> and <code>WasteTypeUtils</code>.',
      'dm.heading':'Data models (details)',
      'state.heading':'State management',
      'log.heading':'Logging/Monitoring',
      'nav.overview': 'Overview',
      'nav.gettingStarted': 'Getting Started',
      'nav.architecture': 'Architecture',
      'nav.localization': 'Localization (l10n)',
      'nav.notifications': 'Notifications',
      'nav.api': 'API Integration',
      'nav.navigation': 'Navigation & Navbar',
      'nav.screens': 'Screens',
      'nav.advanced': 'Advanced Usage',
      'nav.services': 'Services',
      'nav.models': 'Models',
      'nav.theming': 'Theming & UI',
      'nav.accessibility': 'Accessibility',
      'nav.testing': 'Testing & Analysis',
      'nav.troubleshooting': 'Troubleshooting',
      'nav.limitations': 'Known Limitations',
      'nav.roadmap': 'Roadmap',
      'nav.glossary': 'Glossary',
      'nav.versioning': 'Versioning',
      'nav.changelog': 'Changes',
      'nav.links': 'Links',
      'hero.heading': 'Welcome to KOMA App Documentation',
      'hero.lead': 'This documentation is for both end users (how to use) and the technical team (how to develop and maintain).',
      'hero.cta': 'Go to user guide',
      'user.heading': 'User Guide',
      'user.start': 'Getting started',
      'user.step1': 'Open the app — you will see the welcome screen and then the main screen with the bottom navigation.',
      'user.step2': 'Choose an address: go to the Schedule tab (left icon). On first use, an address search appears.',
      'user.step3': 'Type the street and number, pick a suggestion. The app saves the address in history and loads the schedule.',
      'user.schedule': 'Collection schedule',
      'user.schedule1': 'You will find dates and fractions. Names and months are translated automatically to the selected language.',
      'user.schedule2': 'Tap an item to open Fraction details — you will see what to throw and what not.',
      'user.notifications': 'Notifications',
      'user.notif1': 'Open Settings (gear icon on the right).',
      'user.notif2': 'Enable Notifications and choose the Notification time.',
      'user.notif3': 'Send a Test notification to confirm your device displays it correctly.',
      'user.language': 'Language change',
      'user.lang1': 'In Settings expand Language and choose: Polski, English or Українська.',
      'user.lang2': 'The app switches instantly to the chosen language.',
      'user.links': 'External links',
      'user.links1': 'In the bottom navigation the middle icon opens a list: BOK and KOMA Shop.',
      'user.links2': 'After picking, the browser opens with the correct page.',
      'user.tip': 'Tip: if the schedule looks empty, verify the address and make sure the dates are not in the past. In December all months are visible.'
    },
    uk: {
      // Alerts
      'alert.notifWarning':'Попередження: На Android приблизний режим може відхилятися на кілька хвилин від заданого часу.',
      'alert.securityInfo':'Інформація: Додаток не зберігає паролів або секретних ключів у репозиторії.',
      'alert.apiError':'Помилка: Для відповідей 4xx/5xx додаток показує повідомлення і логує деталі у консолі.',
      // Lists content
      'sec.https':'HTTPS для API; у репозиторії немає чутливих секретів.',
      'sec.localData':'Локальні дані: налаштування та історія адрес у <code>SharedPreferences</code>.',
      'sec.perms':'Мінімальні дозволи: сповіщення (+ exact alarm на Android за наявності).',
      'perf.lazy':'Списки будуються ліниво, мінімізуючи зайві перерендери.',
      'perf.filter':'Оптимізована фільтрація розкладу за місяцями і днями.',
      'perf.async':'Без важких операцій у головному потоці; асинхронне I/O.',
      'err.global':'Глобальні <code>FlutterError.onError</code> та <code>PlatformDispatcher.onError</code>.',
      'err.dio':'Dio: відображення помилок (напр., 400/500), резервні UI сценарії.',
      'err.notif':'Сповіщення: розширені логи та діагностика дозволів.',
      'code.small':'Малі компоненти, зрозумілі назви, уникати глибокого вкладення.',
      'code.theme':'Спільні стилі в <code>AppTheme</code>; модульна структура.',
      'code.comments':'Коментарі лише де критично необхідно.',
      'contrib.branch':'Створіть гілку від <em>main</em>.',
      'contrib.ci':'Переконайтеся, що <code>flutter analyze</code> і тести проходять.',
      'contrib.pr':'Надішліть PR з описом обсягу та впливу на UI/API.',
      'release.semver':'SemVer; зміни UI/UX і перекладів фіксуються у <em>Зміни</em>.',
      'release.platforms':'iOS: CocoaPods; Android: Android SDK.',
      'env.dev':'Dev: debug, розширені логи.',
      'env.prod':'Prod: release, зменшені логи.',
      'cfg.api':'<code>config/api_config.dart</code> — типові години, ендпоінти.',
      'cfg.l10n':'<code>l10n.yaml</code> — конфіг генератора локалізації.',
      'ux.clarity':'Зрозумілість, контраст, послідовність компонентів.',
      'ux.nav':'Нижня навігація: послідовні стани, без «білого бару».',
      'l10n.arb':'Усі тексти у <code>.arb</code>; використовуйте <code>AppLocalizations</code>.',
      'l10n.utils':'Місяці/дні: <code>date_utils.dart</code>; фракції: <code>waste_type_utils.dart</code>.',
      'dm.wasteType':'<strong>WasteType</strong>: <em>mixed, paper, glass, metal, bio, ash, bulky, green, elektro, opony</em>.',
      'dm.collection':'<strong>WasteCollection</strong>: <em>day, month, dayOfWeek, wasteType, originalTypeName</em>.',
      'dm.address':'<strong>Address</strong>: <em>prefix, propertyNumber, fullAddress</em>.',
      'state.local':'<code>StatefulWidget</code> + <code>setState</code> (простий, передбачуваний).',
      'state.prefs':'Налаштування: <code>SettingsService</code> (SharedPreferences).',
      'log.notif':'Логи сповіщень: ініціалізація, дозволи, планування.',
      'log.schedule':'Логи розкладу: розміри списків, поточний місяць, крайні елементи.',
      title: 'KOMA App — Документація',
      'nav.security':'Безпека','nav.performance':'Продуктивність','nav.errorHandling':'Обробка помилок','nav.codingStandards':'Стандарти коду','nav.contribution':'Внесок','nav.release':'Випуски та версії','nav.environments':'Середовища','nav.configuration':'Конфігурація','nav.ux':'Настанови UX','nav.l10n':'Настанови локалізації','nav.notificationMatrix':'Матриця сповіщень','nav.apiRef':'API Reference','nav.dataModels':'Моделі даних (деталі)','nav.state':'Керування станом','nav.logging':'Логування/Моніторинг',
      'sec.heading':'Безпека',
      'perf.heading':'Продуктивність',
      'err.heading':'Обробка помилок',
      'code.heading':'Стандарти коду',
      'contrib.heading':'Внесок',
      'release.heading':'Випуски та версії',
      'env.heading':'Середовища',
      'cfg.heading':'Конфігурація',
      'ux.heading':'Настанови UX',
      'l10n.heading':'Настанови локалізації',
      'nm.heading':'Матриця сповіщень','nm.platform':'Платформа','nm.mode':'Режим','nm.perms':'Дозволи','nm.desc':'Опис','nm.exact':'Точний','nm.exactDesc':'Хвилинна точність (якщо дозволено системою)','nm.approx':'Приблизний','nm.approxDesc':'Допуск у кілька хвилин','nm.standard':'Стандарт','nm.iosDesc':'Нативні діалоги, діагностичні логи',
      'api.heading':'API Reference','api.schedule':'Розклад','api.endpoint':'Ендпоінт','api.method':'Метод','api.params':'Параметри','api.response':'Відповідь','api.map':'Відображення на <code>WasteType</code> у <code>ApiService</code> та <code>WasteTypeUtils</code>.',
      'dm.heading':'Моделі даних (деталі)',
      'state.heading':'Керування станом',
      'log.heading':'Логування/Моніторинг',
      'nav.overview': 'Огляд',
      'nav.gettingStarted': 'Початок роботи',
      'nav.architecture': 'Архітектура',
      'nav.localization': 'Локалізація (l10n)',
      'nav.notifications': 'Сповіщення',
      'nav.api': 'Інтеграція з API',
      'nav.navigation': 'Навігація та Navbar',
      'nav.screens': 'Екрани',
      'nav.advanced': 'Розширене використання',
      'nav.services': 'Сервіси',
      'nav.models': 'Моделі',
      'nav.theming': 'Тема та UI',
      'nav.accessibility': 'Доступність',
      'nav.testing': 'Тестування та аналіз',
      'nav.troubleshooting': 'Вирішення проблем',
      'nav.limitations': 'Відомі обмеження',
      'nav.roadmap': 'Дорожня карта',
      'nav.glossary': 'Глосарій',
      'nav.versioning': 'Версіонування',
      'nav.changelog': 'Зміни',
      'nav.links': 'Посилання',
      'hero.heading': 'Ласкаво просимо до документації KOMA App',
      'hero.lead': 'Ця документація призначена для користувачів (як користуватися) та технічної команди (як розвивати і підтримувати).',
      'hero.cta': 'Перейти до інструкції користувача',
      'user.heading': 'Інструкція для користувача',
      'user.start': 'Початок',
      'user.step1': 'Відкрийте застосунок — з’явиться вітальний екран, потім головний екран із нижньою навігацією.',
      'user.step2': 'Виберіть адресу: перейдіть на вкладку Розклад (ліва іконка). При першому запуску з’явиться пошук адреси.',
      'user.step3': 'Введіть вулицю та номер, виберіть підказку. Застосунок збереже адресу в історії та завантажить розклад.',
      'user.schedule': 'Розклад вивозу',
      'user.schedule1': 'У списку знайдете дати та фракції. Назви та місяці перекладаються автоматично відповідно до мови.',
      'user.schedule2': 'Натисніть елемент, щоб відкрити Деталі фракції — що можна і що не можна викидати.',
      'user.notifications': 'Сповіщення',
      'user.notif1': 'Відкрийте Налаштування (іконка шестерні праворуч).',
      'user.notif2': 'Увімкніть Сповіщення та виберіть Час сповіщень.',
      'user.notif3': 'Надішліть Тестове сповіщення, щоб переконатися, що пристрій відображає його.',
      'user.language': 'Мова',
      'user.lang1': 'У Налаштуваннях розгорніть Мову і виберіть: Polski, English або Українська.',
      'user.lang2': 'Застосунок миттєво переключиться на вибрану мову.',
      'user.links': 'Зовнішні посилання',
      'user.links1': 'У нижній навігації середня іконка відкриває список: BOK та Магазин KOMA.',
      'user.links2': 'Після вибору відкриється браузер з потрібною сторінкою.',
      'user.tip': 'Підказка: якщо розклад порожній, перевірте адресу і впевніться, що дати не в минулому. У грудні видно всі місяці.'
    }
  };

  function applyLang(lang){
    const map = dict[lang] || dict.pl;
    i18nNodes.forEach(node => {
      const key = node.getAttribute('data-i18n');
      if(map[key]) node.innerHTML = map[key];
    });
    document.documentElement.lang = lang;
  }

  if(select){
    select.addEventListener('change', () => applyLang(select.value));
  }
  // default
  applyLang(select && select.value || 'pl');

  document.getElementById('sidebar').addEventListener('click', smoothNav);
  if(main){
    main.addEventListener('scroll', onScroll, { passive: true });
  } else {
    window.addEventListener('scroll', onScroll, { passive: true });
  }
  if(input){ input.addEventListener('input', search); }
  onScroll();
})();


