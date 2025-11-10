# 🔧 Instalacja CocoaPods dla iOS

## ❌ Problem:
```
CocoaPods not installed. Skipping pod install.
Error launching application on iPhone 17 Pro.
```

CocoaPods jest **wymagany** do budowania aplikacji Flutter na iOS/macOS.

---

## ✅ Rozwiązanie - Instalacja CocoaPods:

### **Metoda 1: Instalacja przez Homebrew (ZALECANA)** 🍺

#### Krok 1: Sprawdź czy masz Homebrew
```bash
brew --version
```

#### Krok 2a: Jeśli masz Homebrew - zainstaluj CocoaPods
```bash
brew install cocoapods
```

#### Krok 2b: Jeśli NIE masz Homebrew - zainstaluj go najpierw
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
Potem:
```bash
brew install cocoapods
```

---

### **Metoda 2: Instalacja przez Ruby Gems** 💎

#### Krok 1: Sprawdź wersję Ruby
```bash
ruby -v
```
Powinieneś zobaczyć Ruby 2.6 lub nowszy.

#### Krok 2: Zainstaluj CocoaPods
```bash
sudo gem install cocoapods
```
Wpisz swoje hasło macOS gdy zostaniesz zapytany.

#### Krok 3: Jeśli dostajesz błąd uprawnień
```bash
sudo gem install cocoapods -n /usr/local/bin
```

---

### **Metoda 3: Instalacja dla macOS z Apple Silicon (M1/M2/M3)** 🍎

Jeśli masz Mac z procesorem Apple Silicon:

```bash
sudo gem install -n /usr/local/bin ffi
sudo gem install cocoapods
```

Lub przez Homebrew:
```bash
brew install cocoapods
```

---

## 🔍 Weryfikacja Instalacji:

Po instalacji sprawdź czy CocoaPods działa:

```bash
pod --version
```

Powinieneś zobaczyć numer wersji, np. `1.15.2`

---

## 📱 Następne Kroki - Uruchomienie Aplikacji:

### Krok 1: Zainstaluj zależności iOS
```bash
cd ios
pod install
cd ..
```

### Krok 2: Sprawdź czy Pods zostały zainstalowane
Powinieneś zobaczyć:
```
Analyzing dependencies
Downloading dependencies
Installing [różne pakiety]...
Generating Pods project
```

### Krok 3: Uruchom aplikację
```bash
flutter run
```

Lub otwórz w Xcode:
```bash
open ios/Runner.xcworkspace
```
⚠️ **UWAGA:** Otwórz `.xcworkspace`, NIE `.xcodeproj`!

---

## 🐛 Rozwiązywanie Problemów:

### Problem 1: "command not found: pod"
**Rozwiązanie:**
```bash
# Sprawdź PATH
echo $PATH

# Dodaj do PATH (tymczasowo)
export PATH="/usr/local/bin:$PATH"

# Lub dodaj na stałe do ~/.zshrc
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Problem 2: "You don't have write permissions"
**Rozwiązanie:**
```bash
# Użyj sudo
sudo gem install cocoapods

# Lub zainstaluj w user directory
gem install cocoapods --user-install
export PATH="$HOME/.gem/ruby/X.X.X/bin:$PATH"  # Zastąp X.X.X wersją Ruby
```

### Problem 3: "pod install" kończy się błędem
**Rozwiązanie:**
```bash
# Wyczyść cache
cd ios
rm -rf Pods Podfile.lock
pod cache clean --all
pod deintegrate
pod install
cd ..
```

### Problem 4: CocoaPods bardzo wolno instaluje
To normalne przy pierwszej instalacji. Może potrwać 5-15 minut.

### Problem 5: "CDN: trunk URL couldn't be downloaded"
**Rozwiązanie:**
```bash
# Dodaj do Podfile na początku:
# source 'https://github.com/CocoaPods/Specs.git'

cd ios
pod install --repo-update
cd ..
```

---

## 🎯 Szybki Checklist:

- [ ] CocoaPods zainstalowany (`pod --version` działa)
- [ ] `cd ios && pod install` wykonane pomyślnie
- [ ] Folder `ios/Pods` istnieje
- [ ] Plik `ios/Podfile.lock` istnieje
- [ ] `flutter run` działa bez błędów CocoaPods

---

## 📚 Dodatkowe Zasoby:

- **Oficjalna strona CocoaPods:** https://cocoapods.org/
- **Flutter dokumentacja iOS:** https://docs.flutter.dev/get-started/install/macos#ios-setup
- **CocoaPods Getting Started:** https://guides.cocoapods.org/using/getting-started.html

---

## ⚡ Szybka Komenda (Wszystko w Jednym):

Jeśli chcesz zainstalować wszystko jedną komendą:

```bash
# Instalacja CocoaPods (wybierz jedną):
brew install cocoapods || sudo gem install cocoapods

# Instalacja iOS dependencies
cd ios && pod install && cd ..

# Uruchomienie aplikacji
flutter run
```

---

**Data aktualizacji:** 2025-10-22
**Dla:** macOS z Flutter i iOS development

---

## 💡 Pro Tip:

Po zainstalowaniu CocoaPods, przy każdym dodaniu nowego pluginu Flutter, musisz uruchomić:
```bash
cd ios
pod install
cd ..
```

Możesz też użyć:
```bash
flutter pub get
cd ios && pod install && cd ..
```

---

**Status:** Po instalacji CocoaPods powiadomienia na iOS powinny działać! 🚀📱

