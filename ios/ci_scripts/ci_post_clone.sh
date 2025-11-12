#!/bin/bash
set -e
set -o pipefail

echo "--- [CI/CD Flutter Setup - Native] START ---"

# --- Definicja Ścieżek ---
FLUTTER_HOME="$CI_WORKSPACE_PATH/flutter"
REPO_ROOT="../.." # Katalog główny repozytorium

echo "Ścieżki robocze:"
echo "Repozytorium (Root): $REPO_ROOT"
# Katalog iOS: ../ (usunięto definicję, ponieważ w kroku 3 używamy względnej ścieżki "ios")

# 1. Klonowanie i instalacja Flutter SDK (stable) + Dodanie do PATH
echo "1. Klonowanie i instalacja Flutter SDK (stable)..."
git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$FLUTTER_HOME"
export PATH="$PATH:$FLUTTER_HOME/bin"
flutter --version

# --- NOWY KROK ---
# 1.5. Wstępne pobieranie artefaktów silnika iOS
echo "1.5. Pobieranie wstępne artefaktów silnika Flutter dla iOS (flutter precache --ios)..."
flutter precache --ios # <--- TO JEST KLUCZOWA ZMIANA
# --------------------

# 2. Pub Get
echo "2. Uruchamianie 'flutter pub get' w katalogu repozytorium..."
cd "$REPO_ROOT" # Z ios/ci_scripts -> do katalogu głównego
flutter pub get

# 3. Pod Install
echo "3. Uruchamianie 'pod install' w folderze iOS..."
cd ios 
xcrun pod install

echo "--- [CI/CD Flutter Setup - Native] COMPLETED ---"