#!/bin/bash

# Ustawienie opcji, aby skrypt przerwał działanie przy pierwszym błędzie i wyświetlał błędy
set -e
set -o pipefail

echo "--- [CI/CD Flutter Setup] START ---"

# --- Definicja Ścieżek ---
# CI_WORKSPACE_PATH: /Volumes/workspace
# CI_PRIMARY_REPOSITORY_PATH: /Volumes/workspace/repository
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

# Weryfikacja
if [ ! -f "$FLUTTER_CMD" ]; then
    echo "BŁĄD: Nie znaleziono narzędzia Flutter w ścieżce: $FLUTTER_CMD"
    exit 1
fi

echo "Wersja Fluttera:"
"$FLUTTER_CMD" --version

# --- 2. Konfiguracja Ścieżki i Pobieranie Pakietów Fluttera (Pub Get) ---

# Dodanie katalogu bin Fluttera do PATH - kluczowe dla używania 'flutter' i 'pod install'
export PATH="$PATH:$FLUTTER_HOME/bin"
echo "Zaktualizowana zmienna PATH: $PATH"


echo "2. Uruchamianie 'flutter pub get' w katalogu repozytorium..."
# Przejdź do katalogu głównego projektu Fluttera, gdzie jest pubspec.yaml
cd "$REPO_PATH"
flutter pub get

# --- 3. Instalacja CocoaPods ---

echo "3. Uruchamianie 'pod install' w folderze iOS..."
# Przejdź do katalogu ios/
cd "$IOS_PROJECT_PATH"

# Używamy samej komendy, ponieważ PATH została zaktualizowana i Flutter jest w stanie jej użyć
pod install

echo "--- [CI/CD Flutter Setup] COMPLETED ---"