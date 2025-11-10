#!/bin/bash

# Ustawienie opcji, aby skrypt przerwał działanie przy pierwszym błędzie
set -e
set -o pipefail

# --- Definicja Ścieżek ---

# CI_WORKSPACE_PATH: Główny katalog roboczy Xcode Cloud (/Volumes/workspace)
# CI_PRIMARY_REPOSITORY_PATH: Katalog z sklonowanym repozytorium (/Volumes/workspace/repository)
FLUTTER_HOME="$CI_WORKSPACE_PATH/flutter"
FLUTTER_CMD="$FLUTTER_HOME/bin/flutter"
REPO_PATH="$CI_PRIMARY_REPOSITORY_PATH"
IOS_PROJECT_PATH="$REPO_PATH/ios"

echo "Ścieżki robocze:"
echo "Repozytorium: $REPO_PATH"
echo "Katalog iOS: $IOS_PROJECT_PATH"
echo "Docelowy Flutter Home: $FLUTTER_HOME"

# --- 1. Instalacja Flutter SDK ---

echo "1. Klonowanie i instalacja Flutter SDK (stable)..."
# Klonowanie do $FLUTTER_HOME
git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$FLUTTER_HOME"

# Sprawdzenie, czy komenda flutter jest dostępna przez pełną ścieżkę
if [ ! -f "$FLUTTER_CMD" ]; then
    echo "BŁĄD: Nie znaleziono narzędzia Flutter w ścieżce: $FLUTTER_CMD"
    exit 1
fi

echo "Wersja Fluttera:"
"$FLUTTER_CMD" --version

# --- 2. Pobieranie Pakietów Fluttera ---

echo "2. Uruchamianie 'flutter pub get' w katalogu repozytorium..."
cd "$REPO_PATH"
"$FLUTTER_CMD" pub get

# --- 3. Instalacja CocoaPods ---

echo "3. Uruchamianie 'pod install' w folderze iOS..."
cd "$IOS_PROJECT_PATH"

# Po 'flutter pub get', plik Flutter/Generated.xcconfig powinien już istnieć, 
# więc 'pod install' powinien się wykonać poprawnie.
/usr/bin/pod install

echo "--- Konfiguracja CI/CD zakończona pomyślnie. ---"