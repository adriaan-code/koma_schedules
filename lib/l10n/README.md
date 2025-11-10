# 🌍 Lokalizacja / Localization

## Języki / Languages

Aplikacja KOMA wspiera następujące języki:
- 🇵🇱 **Polski** (pl) - domyślny
- 🇬🇧 **Angielski** (en)

## Struktura plików / File Structure

```
lib/l10n/
├── app_pl.arb          # Tłumaczenia polskie (188 kluczy)
├── app_en.arb          # Tłumaczenia angielskie (188 kluczy)
├── app_localizations.dart           # Wygenerowany - główna klasa
├── app_localizations_pl.dart        # Wygenerowany - implementacja PL
├── app_localizations_en.dart        # Wygenerowany - implementacja EN
└── README.md           # Ten plik
```

## Kategorie tłumaczeń / Translation Categories

### 1. Ogólne (General)
- Tytuł aplikacji, przyciski, komunikaty systemowe
- `appTitle`, `back`, `cancel`, `ok`, `search`, `loading`, `error`

### 2. Nawigacja (Navigation)
- Nazwy ekranów w bottom navigation
- `schedule`, `knowledgeBase`, `shop`, `bokPortal`, `notifications`, `settings`

### 3. Wyszukiwanie adresu (Address Search)
- Wszystkie elementy ekranu wyszukiwania adresu
- `addressSearch`, `selectSector`, `selectStreet`, `showSchedule`

### 4. Harmonogram odpadów (Waste Schedule)
- Ekran harmonogramu i szczegóły zbiórek
- `wasteSchedule`, `wasteCollection`, `today`, `tomorrow`

### 5. Wyszukiwanie odpadów (Waste Search)
- Baza wiedzy o odpadach
- `wasteDatabase`, `searchWaste`, `whereToThrow`, `searchAgain`

### 6. Segregacja (Segregation)
- Instrukcje segregacji i przykłady odpadów
- `howToSegregate`, `whatCanBeThrown`, `preparation`

### 7. Ustawienia (Settings)
- Konfiguracja aplikacji
- `reminder`, `language`, `appVersion`, `testNotifications`

### 8. Komunikaty (Messages)
- Błędy, powiadomienia, tooltips
- `noInternetConnection`, `serverError`, `permissionsRequired`

### 9. Daty (Dates)
- Dni tygodnia i miesiące
- `monday`, `tuesday`, `january`, `february`

## Użycie w kodzie / Usage in Code

### Import

```dart
import '../l10n/app_localizations.dart';
```

### Proste tłumaczenia

```dart
// Polski: "Ładowanie..."
// English: "Loading..."
Text(AppLocalizations.of(context)!.loading)
```

### Tłumaczenia z parametrami

```dart
// Polski: "Brak odpadów zaczynających się na \"plastik\""
// English: "No waste starting with \"plastic\""
Text(AppLocalizations.of(context)!.noResultsFor('plastik'))
```

### W widgetach

```dart
ElevatedButton(
  onPressed: () {},
  child: Text(AppLocalizations.of(context)!.searchAgain),
)
```

### Tooltips

```dart
BottomNavigationBarItem(
  icon: Icon(Icons.calendar_month_outlined),
  label: '',
  tooltip: AppLocalizations.of(context)!.scheduleTooltip,
)
```

## Dodawanie nowych tłumaczeń / Adding New Translations

### 1. Dodaj klucz do obu plików ARB

**app_pl.arb:**
```json
{
  "myNewKey": "Moje nowe tłumaczenie",
  "keyWithParam": "Witaj {name}!",
  "@keyWithParam": {
    "placeholders": {
      "name": {
        "type": "String"
      }
    }
  }
}
```

**app_en.arb:**
```json
{
  "myNewKey": "My new translation",
  "keyWithParam": "Hello {name}!",
  "@keyWithParam": {
    "placeholders": {
      "name": {
        "type": "String"
      }
    }
  }
}
```

### 2. Wygeneruj pliki lokalizacji

```bash
flutter gen-l10n
```

### 3. Użyj w kodzie

```dart
Text(AppLocalizations.of(context)!.myNewKey)
Text(AppLocalizations.of(context)!.keyWithParam('John'))
```

## Zmiana języka / Changing Language

Język zmienia się automatycznie na podstawie ustawień systemowych urządzenia.

Aby wymusić konkretny język:

```dart
MaterialApp(
  locale: const Locale('pl'), // lub 'en'
  // ...
)
```

## Best Practices

### ✅ DO

- Używaj opisowych kluczy w camelCase: `wasteSchedule`, `selectSector`
- Grupuj logicznie powiązane klucze
- Dodawaj placeholders dla zmiennych wartości
- Testuj wszystkie tłumaczenia w obu językach

### ❌ DON'T

- Nie używaj podkreślnika na początku klucza: `_myKey` ❌
- Nie hardcoduj tekstów w widgetach
- Nie duplikuj tłumaczeń - używaj istniejących kluczy

## Statystyki / Statistics

- **Całkowita liczba kluczy:** 188
- **Polski:** 188/188 (100%) ✅
- **Angielski:** 188/188 (100%) ✅

## Pokrycie / Coverage

| Kategoria | Klucze | Status |
|-----------|--------|--------|
| Ogólne | 11 | ✅ Kompletne |
| Nawigacja | 7 | ✅ Kompletne |
| Adresy | 22 | ✅ Kompletne |
| Ulubione | 6 | ✅ Kompletne |
| Harmonogram | 10 | ✅ Kompletne |
| Wyszukiwanie odpadów | 13 | ✅ Kompletne |
| Segregacja | 10 | ✅ Kompletne |
| Typy odpadów | 7 | ✅ Kompletne |
| Przykłady odpadów | 42 | ✅ Kompletne |
| Ustawienia | 16 | ✅ Kompletne |
| Powiadomienia | 2 | ✅ Kompletne |
| Uprawnienia | 3 | ✅ Kompletne |
| Dni tygodnia | 7 | ✅ Kompletne |
| Miesiące | 12 | ✅ Kompletne |
| Błędy | 5 | ✅ Kompletne |
| Tooltips | 6 | ✅ Kompletne |

**Total:** 188 kluczy | **Pokrycie:** 100% 🎉

## Konfiguracja / Configuration

Plik `l10n.yaml` w głównym katalogu projektu:

```yaml
arb-dir: lib/l10n
template-arb-file: app_pl.arb
output-localization-file: app_localizations.dart
```

## Wsparcie / Support

Dla pytań dotyczących tłumaczeń:
- Sprawdź istniejące klucze w `app_pl.arb` i `app_en.arb`
- Zobacz oficjalną dokumentację Flutter: https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization
- Zgłoś issue jeśli brakuje kluczowego tłumaczenia

---

**Ostatnia aktualizacja:** 2025-01-21  
**Wersja:** 1.0.0

