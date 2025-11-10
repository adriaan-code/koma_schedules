import 'package:flutter/material.dart';

/// Centralna konfiguracja kolorów i stylów aplikacji
class AppTheme {
  // Kolory główne - jednolite w całej aplikacji
  static const Color primaryBlue = Color(0xFF00569D); // KOMA blue
  static const Color accentGreen = Color(0xFF4CAF50); // Akcenty

  // Kolory tekstu - WCAG AA compliant
  static const Color textPrimary = Color(0xFF212121); // Główny tekst (Colors.black87)
  static const Color textSecondary = Color(0xFF616161); // Drugorzędny tekst
  static const Color textTertiary = Color(0xFF757575); // Pomocniczy tekst
  static const Color textBlack = Color(0xFF000000); // Czysty czarny

  // Kolory tła
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color backgroundGrey = Color(0xFFF5F5F5);
  static const Color backgroundGreyLight = Color(0xFFFAFAFA); // Colors.grey.shade50
  static const Color backgroundGreyMedium = Color(0xFFEEEEEE); // Colors.grey.shade100

  // Kolory interakcji
  static const Color errorRed = Color(0xFFD32F2F);
  static const Color successGreen = Color(0xFF388E3C);
  static const Color warningOrange = Color(0xFFF57C00);

  // Kolory pomocnicze (grey shades)
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);

  // Kolory dla waste types
  static const Color glassGreen = Color.fromRGBO(70, 180, 11, 1);
  static const Color paperBlue = Color.fromRGBO(0, 86, 157, 1);
  static const Color ashGrey = Color(0xFF9E9E9E);
  static const Color brown300 = Color(0xFFBCAAA4);
  static const Color brown400 = Color(0xFFA1887F);
  static const Color brown500 = Color(0xFF8D6E63);
  static const Color brown600 = Color(0xFF795548);
  static const Color brown700 = Color(0xFF6D4C41);
  static const Color brown800 = Color(0xFF5D4037);

  // Border radius - jednolity system
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 20.0;

  // Spacing - jednolity system
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  // Padding - często używane kombinacje
  static const EdgeInsets paddingAll = EdgeInsets.all(spacingMedium);
  static const EdgeInsets paddingHorizontal = EdgeInsets.symmetric(horizontal: spacingMedium);
  static const EdgeInsets paddingVertical = EdgeInsets.symmetric(vertical: spacingMedium);
  static const EdgeInsets paddingBody = EdgeInsets.only(left: spacingMedium, right: spacingMedium);

  // Font sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 20.0;
  static const double fontSizeXLarge = 24.0;
  static const double fontSizeXXLarge = 32.0;

  // Elevation
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;

  // Icon sizes
  static const double iconSizeSmall = 24.0;
  static const double iconSizeMedium = 30.0;
  static const double iconSizeLarge = 40.0;
  static const double iconSizeXLarge = 80.0;

  // Image sizes
  static const double imageSizeSmall = 80.0;
  static const double imageSizeMedium = 120.0;
  static const double imageSizeLarge = 200.0;

  /// Tworzy ThemeData dla aplikacji
  static ThemeData getThemeData() {
    return ThemeData(
      primarySwatch: Colors.green,
      primaryColor: primaryBlue,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.light,
        primary: primaryBlue,
        secondary: accentGreen,
        error: errorRed,
      ),
      // Poprawione kolory dla WCAG AA compliance
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textPrimary, fontSize: fontSizeMedium),
        bodyMedium: TextStyle(color: textPrimary, fontSize: fontSizeMedium),
        bodySmall: TextStyle(color: textSecondary, fontSize: fontSizeSmall),
        labelSmall: TextStyle(color: textTertiary, fontSize: fontSizeSmall),
      ),
      fontFamily: 'Roboto',
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: backgroundWhite,
        foregroundColor: textPrimary,
      ),
      cardTheme: CardThemeData(
        elevation: elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLarge,
            vertical: spacingMedium,
          ),
          elevation: elevationLow,
        ),
      ),
      scaffoldBackgroundColor: backgroundWhite,
    );
  }
}
