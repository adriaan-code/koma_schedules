# Integracja z API KOMA - Instrukcje

## Przegląd

Aplikacja została zintegrowana z prawdziwym API KOMA do pobierania danych o miejscowościach i harmonogramie odbiorów odpadów.

## Struktura API KOMA

### Endpointy

1. **GET /sektory** - Pobiera wszystkie sektory i miejscowości
   - URL: `https://bok.koma.pl/api/sektory`
   - Zwraca: Mapę sektorów z miejscowościami
   - **✅ ZAIMPLEMENTOWANE**

2. **GET /ulice/{prefix}/{gmina}/{miejscowosc}** - Pobiera ulice dla danego prefiksu, gminy i miejscowości
   - URL: `https://bok.koma.pl/api/ulice/{prefix}/{gmina}/{miejscowosc}`
   - Zwraca: Lista ulic
   - **✅ ZAIMPLEMENTOWANE**

3. **GET /posesje/{prefix}/{gmina}/{miejscowosc}/{ulica}** - Pobiera posesje dla danej ulicy
   - URL: `https://bok.koma.pl/api/posesje/{prefix}/{gmina}/{miejscowosc}/{ulica}`
   - Zwraca: Lista posesji (numerów domów)
   - **✅ ZAIMPLEMENTOWANE**

4. **GET /apiharmonogram?value={prefix}/{nr_posesji}** - Pobiera harmonogram odbiorów dla danej posesji
   - URL: `https://bok.koma.pl/api/apiharmonogram?value={prefix}/{nr_posesji}`
   - Przykład: `https://bok.koma.pl/api/apiharmonogram?value=Biała Piska/1A`
   - Zwraca: Harmonogram odbiorów odpadów
   - **🔄 DO IMPLEMENTACJI**

5. **GET /typy-odpadow** - Pobiera szczegóły typu odpadu
   - Parametry: `type` (typ odpadu)
   - Zwraca: Szczegóły typu odpadu
   - **🔄 DO IMPLEMENTACJI**

### Format danych API KOMA

#### Endpoint /sektory (✅ ZAIMPLEMENTOWANE)

```json
{
  "Ełk": {
    "Biała Piska": [
      {"gmina": "Biała Piska", "miejscowosc": "Bemowo Piskie"},
      {"gmina": "Biała Piska", "miejscowosc": "Bełcząc"},
      {"gmina": "Biała Piska", "miejscowosc": "Biała Piska"}
    ],
    "Dubeninki": [
      {"gmina": "Dubeninki", "miejscowosc": "Barcie"},
      {"gmina": "Dubeninki", "miejscowosc": "Będziszewo"}
    ]
  },
  "Lublin": {
    "Lublin": [
      {"gmina": "Lublin", "miejscowosc": "Lublin"}
    ]
  }
}
```

**Struktura hierarchiczna:**
1. **Poziom 1 - Sektor** (np. "Ełk", "Lublin")
2. **Poziom 2 - Prefiks** (np. "Biała Piska", "Dubeninki")  
3. **Poziom 3 - Miejscowości** (tablica obiektów z gmina i miejscowosc)

#### Endpoint /ulice/{prefix}/{gmina}/{miejscowosc} (✅ ZAIMPLEMENTOWANE)

```json
[
  {
    "prefix": "Biała Piska",
    "gmina": "Biała Piska", 
    "miejscowosc": "Bemowo Piskie",
    "ulica": "Główna"
  },
  {
    "prefix": "Biała Piska",
    "gmina": "Biała Piska",
    "miejscowosc": "Bemowo Piskie", 
    "ulica": "Leśna"
  }
]
```

#### Endpoint /posesje/{prefix}/{gmina}/{miejscowosc}/{ulica} (✅ ZAIMPLEMENTOWANE)

```json
[
  {
    "numer": "1",
    "dodatkowy": "A",
    "gmina": "Biała Piska",
    "miejscowosc": "Bemowo Piskie",
    "ulica": "Główna"
  },
  {
    "numer": "2",
    "dodatkowy": null,
    "gmina": "Biała Piska", 
    "miejscowosc": "Bemowo Piskie",
    "ulica": "Główna"
  },
  {
    "numer": "3",
    "dodatkowy": "B",
    "gmina": "Biała Piska",
    "miejscowosc": "Bemowo Piskie", 
    "ulica": "Główna"
  }
]
```

#### Endpoint /apiharmonogram?value={prefix}/{nr_posesji} (🔄 DO IMPLEMENTACJI)

```json
{
  "posesja": {
    "prefix": "Biała Piska",
    "numer": "1A",
    "gmina": "Biała Piska",
    "miejscowosc": "Bemowo Piskie",
    "ulica": "Główna"
  },
  "collections": [
    {
      "date": "2024-06-21T00:00:00Z",
      "wasteType": "zmieszane",
      "startTime": "06:00",
      "endTime": "20:00",
      "notes": null
    },
    {
      "date": "2024-06-25T00:00:00Z", 
      "wasteType": "papier",
      "startTime": "07:00",
      "endTime": "18:00",
      "notes": "Segregacja obowiązkowa"
    }
  ],
  "lastUpdated": "2024-06-15T10:30:00Z"
}
```

## Konfiguracja

### 1. URL API już skonfigurowany

W pliku `lib/config/api_config.dart`:
```dart
static const String baseUrl = 'https://bok.koma.pl/api';
```

### 2. Instalacja zależności

```bash
flutter pub get
```

## Funkcjonalności

### ✅ Zaimplementowane

- **Pobieranie miejscowości** z API KOMA (`/sektory`)
- **Wyszukiwanie miejscowości** - wyszukiwanie po nazwie miejscowości i gminie
- **Loading states** - wskaźnik ładowania w pasku wyszukiwania
- **Error handling** - obsługa błędów z przyciskiem "Spróbuj ponownie"
- **Real-time search** - wyszukiwanie podczas pisania
- **Fallback data** - przykładowe dane w przypadku błędu API
- **Obsługa polskich znaków** - poprawna obsługa ą, ć, ę, ł, ń, ó, ś, ź, ż

### 🔄 Automatyczne funkcje

- **Sortowanie** - daty automatycznie sortowane
- **Grupowanie** - według miesięcy
- **Mapowanie typów** - string na enum WasteType
- **Konwersja dat** - z ISO na polskie formaty

## Kolory frakcji

```dart
ZMIENIANE - czarny (Colors.black)
GABARYTY - fioletowy (Colors.purple)
PAPIER - niebieski (Colors.blue)
SZKŁO - zielone (Colors.green)
METAL I TWORZYWA SZTUCZNE - żółty (Colors.yellow)
BIO - brązowy (Colors.brown)
```

## Obsługa błędów

Aplikacja obsługuje następujące błędy:
- **Timeout** - przekroczony czas oczekiwania
- **404** - nie znaleziono harmonogramu
- **500** - błąd serwera
- **Brak internetu** - problem z połączeniem

## Następne kroki

1. **Zmień URL API** w `api_config.dart`
2. **Dostosuj format danych** jeśli Twoje API ma inny format
3. **Dodaj autoryzację** jeśli wymagana
4. **Przetestuj** z prawdziwymi danymi

## Testowanie

Aby przetestować bez API, aplikacja automatycznie używa przykładowych danych w przypadku błędu połączenia.
