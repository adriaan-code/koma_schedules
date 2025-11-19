# 🗑️ KOMA App - Aplikacja Harmonogramu Odbioru Odpadów

Aplikacja mobilna Flutter do zarządzania harmonogramem odbioru odpadów dla mieszkańców.

## 📱 Funkcje

- ✅ Harmonogram odbioru odpadów
- ✅ Wyszukiwanie rodzajów odpadów
- ✅ Powiadomienia o zbliżających się odbiórach
- ✅ Mapa punktów zbiórki odpadów
- ✅ Wsparcie dla języka polskiego, angielskiego i niemieckiego

## 🚀 Instalacja

### Wymagania
- Flutter SDK (wersja 3.0+)
- **iOS**: Xcode 14+, CocoaPods
- **Android**: Android Studio, SDK 21+

### Szybki Start

#### Android:
```bash
flutter pub get
flutter run
```

#### iOS:
⚠️ **Najpierw zainstaluj CocoaPods!** Zobacz: [INSTALL_COCOAPODS.md](INSTALL_COCOAPODS.md)

```bash
flutter pub get
cd ios
pod install
cd ..
flutter run
```

## 📋 Dokumentacja

- **[API_INTEGRATION.md](API_INTEGRATION.md)** - Dokumentacja integracji z API KOMA
- **[TESTING_NOTIFICATIONS.md](TESTING_NOTIFICATIONS.md)** - Jak testować powiadomienia
- **[INSTALL_COCOAPODS.md](INSTALL_COCOAPODS.md)** - Instalacja CocoaPods dla iOS
- **[WONDERPUSH_SETUP.md](WONDERPUSH_SETUP.md)** - Konfiguracja zdalnych pushy (WonderPush)
- **[OPTIMIZATION_REPORT.md](OPTIMIZATION_REPORT.md)** - Raport optymalizacji

## 🔔 Konfiguracja WonderPush (skrót)

1. Uzyskaj `Client ID`, `Client Secret` oraz `Firebase Sender ID` w panelu WonderPush.
2. Uzupełnij `android/local.properties` (`wonderpush.clientId`, `wonderpush.clientSecret`, `wonderpush.senderId`).
3. W `ios/Runner/Info.plist` wpisz własne `WonderPushClientId` oraz `WonderPushClientSecret`, a w `Runner.entitlements` ustaw poprawne `aps-environment`.
4. Uruchom `flutter pub get` i (na iOS) `cd ios && pod install`.
5. Zbuduj aplikację i przetestuj wysyłkę powiadomień z dashboardu WonderPush.

## 🔧 Budowanie

### Android APK:
```bash
flutter build apk --release
```

### iOS (wymaga Apple Developer Account):
```bash
flutter build ios --release
```

## 🧪 Testowanie Powiadomień

Szczegółowa instrukcja w [TESTING_NOTIFICATIONS.md](TESTING_NOTIFICATIONS.md)

**Szybki test:**
1. Uruchom aplikację
2. Przejdź do Ustawień (⚙️)
3. Włącz "Powiadomienia"
4. Kliknij "Test" w sekcji "Test powiadomień"

⚠️ **iOS**: Musisz testować na prawdziwym iPhone (symulator nie obsługuje powiadomień)

## 📦 Struktura Projektu

```
lib/
├── config/          # Konfiguracja (API, theme)
├── data/            # Dane statyczne (JSON)
├── l10n/            # Lokalizacje (PL, EN, DE)
├── models/          # Modele danych
├── navigation/      # Nawigacja
├── screens/         # Ekrany aplikacji
├── services/        # Serwisy (API, powiadomienia, lokalizacja)
└── widgets/         # Komponenty wielokrotnego użytku
```

## 🐛 Rozwiązywanie Problemów

### CocoaPods nie zainstalowany (iOS)
```
Error: CocoaPods not installed
```
**Rozwiązanie:** Zobacz [INSTALL_COCOAPODS.md](INSTALL_COCOAPODS.md)

### Powiadomienia nie działają
**Rozwiązanie:** Zobacz [TESTING_NOTIFICATIONS.md](TESTING_NOTIFICATIONS.md)

### Błąd kompilacji Android
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

## 📄 Licencja

© 2025 KOMA App. Wszystkie prawa zastrzeżone.

## 🤝 Kontakt

Aby zgłosić problem lub zaproponować funkcję, utwórz Issue w repozytorium.
