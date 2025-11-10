#!/bin/bash
set -e
set -o pipefail

echo "--- [CI/CD Flutter Setup - Native] START ---"

# --- Definicja Ścieżek ---
# CI_WORKSPACE_PATH: /Volumes/workspace
FLUTTER_HOME="$CI_WORKSPACE_PATH/flutter"
FLUTTER_CMD="$FLUTTER_HOME/bin/flutter"

# Ścieżki względne, skoro skrypt jest w ios/ci_scripts/
REPO_PATH="../.."
IOS_PROJECT_PATH=".."

echo "Ścieżki robocze:"
echo "Repozytorium: $REPO_PATH"
echo "Katalog iOS: $IOS_PROJECT_PATH"

# ... (Reszta skryptu pozostaje taka sama) ...
# Pamiętaj, aby zmienić "cd $REPO_PATH" i "cd $IOS_PROJECT_PATH"

# 1. Instalacja Flutter SDK (jak poprzednio, bez zmian)
echo "1. Klonowanie i instalacja Flutter SDK..."
git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$FLUTTER_HOME"
export PATH="$PATH:$FLUTTER_HOME/bin"
flutter --version

# 2. Pub Get
echo "2. Uruchamianie 'flutter pub get' w katalogu repozytorium..."
# Wejście do katalogu głównego (ios/ci_scripts -> ../.. -> katalog główny)
cd "$REPO_PATH"
flutter pub get

# 3. Pod Install
echo "3. Uruchamianie 'pod install' w folderze iOS..."
# Wejście do katalogu ios (katalog główny -> ios)
cd "$IOS_PROJECT_PATH"
/usr/bin/pod install

echo "--- [CI/CD Flutter Setup - Native] COMPLETED ---"