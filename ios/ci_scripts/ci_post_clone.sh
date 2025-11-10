#!/bin/sh

# Ustawienie ścieżki do Flutter SDK
export PATH="$HOME/bin:$HOME/flutter/bin:$PATH"
export FLUTTER_ROOT="$HOME/flutter"

# Przejście do głównego katalogu Fluttera (katalog nadrzędny wobec 'ios')
echo "Changing directory to Flutter root..."
cd ..

# 1. Zainstaluj zależności Fluttera/Darta
echo "Running flutter pub get..."
flutter pub get

# 2. Wróć do folderu iOS
echo "Running pod install in ios folder..."
cd ios

# 3. Zainstaluj natywne zależności
pod install