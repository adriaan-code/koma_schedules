# WonderPush – Konfiguracja

Poniższy opis zbiera wszystkie kroki potrzebne do uruchomienia zdalnych powiadomień push za pomocą [WonderPush](https://www.wonderpush.com/) w projekcie Flutter (`koma_app`).

> ⚠️ **Wymagane dane:** `Client ID`, `Client Secret` oraz **Firebase Sender ID** (FCM) wygenerowane w panelu WonderPush.

## 1. Flutter

1. Zainstaluj zależności:
   ```bash
   flutter pub get
   ```
2. Uruchom aplikację po konfiguracji natywnej (`flutter run`, `flutter build …`).

## 2. Android

1. W pliku `android/local.properties` (nie jest wersjonowany) dodaj:
   ```
   wonderpush.clientId=WP_xxxxxxxxxxxxxxxxx
   wonderpush.clientSecret=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
   wonderpush.senderId=123456789012
   ```
2. Nic więcej nie trzeba robić – build script automatycznie przekaże wartości do `BuildConfig`, a klasa `KomaApplication` zainicjuje WonderPush podczas startu aplikacji.

## 3. iOS

1. Uzupełnij klucze w `ios/Runner/Info.plist`:
   ```xml
   <key>WonderPushClientId</key>
   <string>WP_xxxxxxxxxxxxxxxxx</string>
   <key>WonderPushClientSecret</key>
   <string>xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx</string>
   ```
2. Upewnij się, że `ios/Runner/Runner.entitlements` zawiera odpowiednie środowisko (`development` lub `production`) w kluczu `aps-environment`.
3. Zainstaluj zależności CocoaPods:
   ```bash
   cd ios
   pod install
   cd ..
   ```
4. W Xcode włącz `Push Notifications` oraz `Background Modes > Remote notifications` (pliki projektu są już przygotowane, ale Xcode może wymagać odświeżenia uprawnień).

## 4. Sprawdzenie działania

1. Zbuduj aplikację (`flutter run` lub `flutter build ios/android`).
2. Po zainstalowaniu aplikacji:
   - na iOS zostanie wyświetlony systemowy prompt o zgodę na powiadomienia (wywołany przez `WonderPush.subscribeToNotifications()`),
   - na Androidzie użytkownik zostaje zasubskrybowany automatycznie (Android 13+ poprosi o `POST_NOTIFICATIONS`).
3. Wyślij powiadomienie testowe z dashboardu WonderPush i zweryfikuj, że urządzenie otrzymuje je poprawnie.

## 5. Dodatkowe informacje

- `lib/services/wonderpush_service.dart` udostępnia prosty wrapper na potrzeby aplikacji (logowanie, obsługa delegata, zarządzanie subskrypcją).
- Przełącznik „Powiadomienia” w ekranie Ustawień uruchamia/wyłącza zarówno lokalne przypomnienia (`flutter_local_notifications`), jak i subskrypcję WonderPush.
- Jeśli chcesz przechowywać sekrety poza repozytorium, dodaj własne mechanizmy nadpisujące wartości przed buildem (np. `xcodebuild -xcconfig`, `gradle.properties`).

Powodzenia! W razie pytań zobacz też [oficjalny przewodnik WonderPush dla Fluttera](https://docs.wonderpush.com/docs/flutter-push-notifications).

