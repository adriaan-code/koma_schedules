# 🎨 Aktualizacja Splash Screen - Białe Tło + Logo KOMA

**Data:** 2025-10-21  
**Status:** ✅ **GOTOWE - WYMAGA LOGO**

---

## 🎯 Zmiany

### **1. Zmiana Tła na Białe**
- ✅ **Flutter splash screen** - białe tło
- ✅ **Natywny splash screen** - białe tło (#FFFFFF)
- ✅ **Kolory UI** - dostosowane do białego tła

### **2. Logo KOMA**
- ✅ **Image.asset** - obsługa logo z assets/img/koma_logo.png
- ✅ **Fallback** - alternatywne logo tekstowe jeśli plik nie istnieje
- ✅ **Rozmiar** - 200x200px
- ✅ **Animacje** - fade in i scale

### **3. Kolory UI**
- 🎨 **Tło:** Białe (#FFFFFF)
- 🎨 **Logo:** Z pliku assets/img/koma_logo.png
- 🔵 **Spinner:** Niebieski (AppTheme.primaryBlue)
- 🔘 **Tekst:** Szary (AppTheme.textSecondary)

---

## 📁 Wymagane Kroki

### **WAŻNE: Dodaj Logo KOMA**

Aby splash screen działał z prawdziwym logo, musisz:

1. **Stwórz folder** (jeśli nie istnieje):
   ```bash
   mkdir -p assets/img
   ```

2. **Dodaj plik logo:**
   - Nazwa: `koma_logo.png`
   - Ścieżka: `assets/img/koma_logo.png`
   - Format: PNG (z przezroczystym tłem zalecane)
   - Rozmiar zalecany: 512x512px lub większy (zostanie przeskalowane do 200x200)

3. **Wygeneruj natywne splash screens:**
   ```bash
   flutter pub run flutter_native_splash:create
   ```

4. **Zainstaluj zależności iOS:**
   ```bash
   cd ios && pod install && cd ..
   ```

---

## 🎨 Design

### **Aktualny Wygląd:**
```
┌─────────────────────────┐
│      BIAŁE TŁO          │
│                         │
│     [LOGO KOMA]         │ ← 200x200px, animowane
│                         │
│                         │
│        [⏳]              │ ← Niebieski spinner
│      Ładowanie...       │ ← Szary tekst
│                         │
└─────────────────────────┘
```

### **Fallback (bez logo):**
Jeśli plik `assets/img/koma_logo.png` nie istnieje, pojawi się:
```
┌─────────────────────────┐
│      BIAŁE TŁO          │
│                         │
│    ┌──────────────┐     │
│    │              │     │
│    │     KOMA     │     │ ← Niebieski kontener z tekstem
│    │              │     │
│    └──────────────┘     │
│                         │
│        [⏳]              │ ← Niebieski spinner
│      Ładowanie...       │ ← Szary tekst
│                         │
└─────────────────────────┘
```

---

## 📊 Zmodyfikowane Pliki

### **1. lib/screens/splash_screen.dart**
```dart
// PRZED
backgroundColor: AppTheme.primaryBlue,
Icon(Icons.recycling, size: 64, color: AppTheme.primaryBlue)

// PO
backgroundColor: AppTheme.backgroundWhite,
Image.asset('assets/img/koma_logo.png', width: 200, height: 200)
```

**Funkcje:**
- ✅ Białe tło
- ✅ Image.asset dla logo KOMA
- ✅ errorBuilder z fallback
- ✅ Animacje fade in i scale
- ✅ Niebieski spinner
- ✅ Szary tekst

### **2. pubspec.yaml**
```yaml
# Dodano ścieżkę do assets
assets:
  - lib/data/
  - assets/img/  # ← NOWE

# Zaktualizowano konfigurację splash screen
flutter_native_splash:
  color: "#FFFFFF"  # ← Białe tło
  image: assets/img/koma_logo.png  # ← Logo KOMA
  android_12:
    image: assets/img/koma_logo.png
    icon_background_color: "#FFFFFF"
```

---

## 🚀 Uruchomienie

### **Po Dodaniu Logo:**

1. **Wygeneruj natywne splash screens:**
   ```bash
   flutter pub run flutter_native_splash:create
   ```

2. **Zainstaluj pody iOS:**
   ```bash
   cd ios && pod install && cd ..
   ```

3. **Uruchom aplikację:**
   ```bash
   flutter run
   ```

### **Jeśli Logo Jeszcze Nie Istnieje:**

Aplikacja i tak będzie działać - pokaże się fallback z tekstem "KOMA" w niebieskim kontenerze.

---

## 📱 Wynik

### **Z Logo:**
- ✅ **Białe tło**
- ✅ **Logo KOMA** (200x200px, wyśrodkowane)
- ✅ **Płynne animacje** (fade in + scale)
- ✅ **Niebieski spinner**
- ✅ **Szary tekst "Ładowanie..."**

### **Bez Logo (Fallback):**
- ✅ **Białe tło**
- ✅ **Niebieski kontener z tekstem "KOMA"**
- ✅ **Płynne animacje**
- ✅ **Niebieski spinner**
- ✅ **Szary tekst "Ładowanie..."**

---

## 🎯 Następne Kroki

1. **Dodaj plik logo:**
   - Skopiuj logo KOMA do `assets/img/koma_logo.png`
   - Zalecany format: PNG z przezroczystym tłem
   - Zalecany rozmiar: 512x512px lub większy

2. **Wygeneruj natywne splash screens:**
   ```bash
   flutter pub run flutter_native_splash:create
   ```

3. **Przetestuj:**
   ```bash
   flutter run
   ```

---

## 🔧 Kompatybilność

- ✅ **iOS** - białe tło + logo
- ✅ **Android** - białe tło + logo
- ✅ **Android 12+** - biały icon background
- ✅ **Fallback** - działa bez logo

---

**Status:** ✅ **Gotowe do użycia** (wymaga tylko dodania pliku logo)

**Autor:** AI Assistant  
**Data:** 2025-10-21
