# 🔔 Testowanie Powiadomień w Aplikacji KOMA

## ✅ Co zostało zrobione:

### 1. **Android - AndroidManifest.xml**
- ✅ Receiver dla powiadomień zaplanowanych
- ✅ Receiver dla powiadomień po restarcie telefonu
- ✅ Uprawnienia `POST_NOTIFICATIONS`, `SCHEDULE_EXACT_ALARM`, `USE_EXACT_ALARM`
- ✅ Flagi `showWhenLocked` i `turnScreenOn` dla Activity

### 2. **iOS - Konfiguracja**
- ✅ **AppDelegate.swift** - Dodano delegate dla UNUserNotificationCenter
- ✅ **Info.plist** - NSUserNotificationsUsageDescription
- ✅ **Info.plist** - UIBackgroundModes (fetch, remote-notification)
- ✅ **Podfile** - Platform iOS 13.0+

### 3. **NotificationService** - Ulepszona obsługa
- ✅ Auto-inicjalizacja przy pierwszym użyciu
- ✅ Lepsza obsługa błędów z logowaniem
- ✅ Zwiększona ważność powiadomień (`Importance.max`)
- ✅ Włączone wibracje i dźwięk
- ✅ **iOS**: Automatyczne proszenie o uprawnienia
- ✅ **iOS**: Timezone ustawiona na Europe/Warsaw
- ✅ **iOS**: defaultPresentAlert, defaultPresentSound, defaultPresentBadge

### 4. **SettingsScreen** - Obsługa błędów
- ✅ Try-catch przy wysyłaniu testowego powiadomienia
- ✅ Kolorowe komunikaty (zielony = sukces, czerwony = błąd)
- ✅ Wyświetlanie szczegółów błędu

---

## 📱 Jak Przetestować Powiadomienia:

### **Krok 1: Zbuduj aplikację**

#### **Android:**
```bash
flutter build apk --debug
```
Lub zainstaluj bezpośrednio:
```bash
flutter run
```

#### **iOS:**

⚠️ **WYMAGANE:** CocoaPods musi być zainstalowany!
Jeśli dostajesz błąd "CocoaPods not installed", zobacz: **[INSTALL_COCOAPODS.md](INSTALL_COCOAPODS.md)**

```bash
cd ios
pod install
cd ..
flutter run
```
Lub otwórz w Xcode:
```bash
open ios/Runner.xcworkspace
```

### **Krok 2: Uruchom aplikację na urządzeniu**
⚠️ **WAŻNE:** 
- **Android**: Testuj na prawdziwym urządzeniu (nie w emulatorze)
- **iOS**: Testuj na prawdziwym iPhone (nie w symulatorze iOS) - powiadomienia lokalne nie działają w symulatorze!

### **Krok 3: Przejdź do Ustawień**
1. Otwórz aplikację KOMA
2. Kliknij ikonę **⚙️ Ustawienia** w dolnej nawigacji

### **Krok 4: Włącz powiadomienia**
1. Znajdź przełącznik **"Powiadomienia"**
2. Włącz go (przełącznik powinien być niebieski)

### **Krok 5: Nadaj uprawnienia**

#### **Android:**
Po włączeniu powiadomień, Android poprosi o uprawnienia:
- ✅ **Zezwól** na powiadomienia
- ✅ **Zezwól** na dokładne alarmy (jeśli zostaniesz zapytany)

#### **iOS:**
Aplikacja automatycznie poprosi o uprawnienia przy pierwszym uruchomieniu:
- ✅ Kliknij **"Zezwól"** w dialogu systemowym
- ✅ Jeśli odrzuciłeś, przejdź do: Ustawienia → KOMA App → Powiadomienia → Włącz

### **Krok 6: Wyślij testowe powiadomienie**
1. Przewiń w dół do sekcji **"Test powiadomień"**
2. Kliknij niebieski przycisk **"Test"**
3. Powinieneś zobaczyć:
   - Zielony snackbar na dole ekranu: "Testowe powiadomienie wysłane"
   - **Powiadomienie w pasku powiadomień** z tytułem "Test powiadomienia"

### **Krok 7: Sprawdź zaplanowane powiadomienia**
1. Kliknij zielony przycisk **"Sprawdź"** obok "Test"
2. Zobaczysz komunikat z liczbą zaplanowanych powiadomień

---

## 🐛 Rozwiązywanie Problemów:

### Problem 1: Nie widzę powiadomienia
**Rozwiązanie:**
1. Sprawdź ustawienia systemu Android:
   - Ustawienia → Aplikacje → KOMA App → Powiadomienia
   - Upewnij się, że powiadomienia są włączone
2. Sprawdź, czy nie masz trybu "Nie przeszkadzać"
3. Sprawdź, czy aplikacja ma uprawnienie do powiadomień

### Problem 2: Czerwony komunikat błędu
**Rozwiązanie:**
1. Zanotuj treść błędu
2. Sprawdź logi w terminalu:
   ```bash
   flutter run
   ```
   Szukaj linii z `Błąd wysyłania testowego powiadomienia`

### Problem 3: Powiadomienia działają, ale nie po restarcie (Android)
**Rozwiązanie:**
1. Upewnij się, że aplikacja ma uprawnienie `RECEIVE_BOOT_COMPLETED`
2. Sprawdź, czy w ustawieniach telefonu aplikacja nie jest "optymalizowana" (zabijana w tle)
3. W ustawieniach Android: Bateria → Optymalizacja baterii → KOMA App → Nie optymalizuj

### Problem 4: Powiadomienia nie działają na iOS
**Rozwiązanie:**
1. **Musisz testować na prawdziwym iPhone** - symulator iOS nie obsługuje lokalnych powiadomień!
2. Sprawdź uprawnienia: Ustawienia → KOMA App → Powiadomienia → Włącz wszystkie opcje
3. Sprawdź, czy nie masz włączonego "Nie przeszkadzać" lub "Trybu skupienia"
4. Jeśli to nie pomaga, odinstaluj aplikację i zainstaluj ponownie (żeby system zapytał o uprawnienia jeszcze raz)
5. Sprawdź logi w Xcode:
   ```bash
   open ios/Runner.xcworkspace
   # Uruchom z Xcode i sprawdź konsole
   ```

### Problem 5: iOS - "Building for iOS, but no valid signing certificate"
**Rozwiązanie:**
1. Otwórz projekt w Xcode: `open ios/Runner.xcworkspace`
2. Wybierz Runner w lewym panelu
3. W zakładce "Signing & Capabilities":
   - Zaznacz "Automatically manage signing"
   - Wybierz swój Apple Developer Team
   - Lub użyj "Personal Team" (wymaga Apple ID)

---

## 📋 Checklist dla Testera:

- [ ] Aplikacja zainstalowana na prawdziwym urządzeniu Android
- [ ] Powiadomienia włączone w aplikacji KOMA
- [ ] Uprawnienia nadane w systemie Android
- [ ] Kliknięty przycisk "Test" w ustawieniach
- [ ] Zielony snackbar potwierdzający wysłanie
- [ ] Powiadomienie widoczne w pasku powiadomień
- [ ] Przycisk "Sprawdź" pokazuje liczbę zaplanowanych powiadomień

---

## 🔧 Techniczne Szczegóły:

### Pliki zmodyfikowane:

#### **Android:**
1. `android/app/src/main/AndroidManifest.xml` - Dodano receivery i uprawnienia

#### **iOS:**
2. `ios/Runner/AppDelegate.swift` - Dodano UNUserNotificationCenter delegate
3. `ios/Runner/Info.plist` - Dodano UIBackgroundModes
4. `ios/Podfile` - Odkomentowano platform iOS 13.0

#### **Wspólne:**
5. `lib/services/notification_service.dart` - Ulepszona obsługa iOS i Android
6. `lib/screens/settings_screen.dart` - Dodano obsługę błędów
7. `TESTING_NOTIFICATIONS.md` - Dokumentacja (ten plik)

### Kanały powiadomień:
- `test_channel` - Testowe powiadomienia
- `waste_reminder` - Codzienne przypomnienia o odpadach
- `waste_today` - Powiadomienia o odpadach na dzisiaj

### ID powiadomień:
- `999` - Testowe powiadomienie
- `0` - Codzienne przypomnienie
- `1` - Odpady na dzisiaj

---

## 📞 Wsparcie:

Jeśli powiadomienia nadal nie działają:
1. Sprawdź wersję Androida (min. Android 5.0)
2. Sprawdź, czy `flutter_local_notifications` jest w `pubspec.yaml`
3. Sprawdź logi: `flutter run` i szukaj błędów związanych z powiadomieniami

---

**Data aktualizacji:** 2025-10-22
**Wersja aplikacji:** 1.0.0


