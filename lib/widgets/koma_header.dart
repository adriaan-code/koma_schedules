import 'package:flutter/material.dart';
import '../config/app_theme.dart';

/// Spójny header z logo KOMA dla różnych ekranów
class KomaHeader extends StatelessWidget {
  const KomaHeader({
    super.key,
    this.mainText,
    this.customContent,
    this.onMainTextTap,
    this.showLogo = true,
    this.logoColor = AppTheme.primaryBlue,
  });

  /// Factory dla header z adresem (harmonogram)
  factory KomaHeader.withAddress({
    required String address,
    required VoidCallback onAddressTap,
    Color logoColor = AppTheme.primaryBlue,
  }) {
    return KomaHeader(
      customContent: _AddressWidget(address: address, onTap: onAddressTap),
      logoColor: logoColor,
    );
  }

  /// Factory dla header z tytułem (inne ekrany)
  factory KomaHeader.withTitle({
    required String title,
    Color logoColor = AppTheme.accentGreen,
  }) {
    return KomaHeader(mainText: title, logoColor: logoColor);
  }

  /// Factory dla header z samym logo po prawej stronie
  factory KomaHeader.logoOnly({Color logoColor = AppTheme.primaryBlue}) {
    return KomaHeader(
      mainText: null,
      customContent: null,
      logoColor: logoColor,
    );
  }

  final String? mainText;
  final Widget? customContent;
  final VoidCallback? onMainTextTap;
  final bool showLogo;
  final Color logoColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMedium,
        vertical: AppTheme.spacingMedium,
      ),
      child: Row(
        children: [
          // Lewa strona - custom content lub tekst
          Expanded(
            child:
                customContent ??
                (mainText != null
                    ? _TitleWidget(text: mainText!, onTap: onMainTextTap)
                    : const SizedBox.shrink()),
          ),
          // Prawa strona - logo KOMA
          if (showLogo) _KomaLogo(color: logoColor),
        ],
      ),
    );
  }
}

/// Widget adresu z możliwością kliknięcia
class _AddressWidget extends StatelessWidget {
  const _AddressWidget({required this.address, required this.onTap});

  final String address;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Flexible(
            child: Text(
              address,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: AppTheme.fontSizeMedium,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppTheme.spacingXSmall),
          const Icon(
            Icons.keyboard_arrow_down,
            color: AppTheme.textPrimary,
            size: 18,
          ),
        ],
      ),
    );
  }
}

/// Widget tytułu
class _TitleWidget extends StatelessWidget {
  const _TitleWidget({required this.text, this.onTap});

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      style: const TextStyle(
        fontSize: AppTheme.fontSizeXLarge,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimary,
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: textWidget);
    }

    return textWidget;
  }
}

/// Logo KOMA - wydzielony widget dla lepszej wydajności
class _KomaLogo extends StatelessWidget {
  const _KomaLogo({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/img/logo.png',
      width: 80,

      errorBuilder: (context, error, stackTrace) {
        // Fallback jeśli logo nie istnieje
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        );
      },
    );
  }
}

/// Rozszerzona wersja header dla waste search z podtytułem
class KomaHeaderWithSubtitle extends StatelessWidget {
  const KomaHeaderWithSubtitle({
    super.key,
    required this.title,
    required this.subtitle,
    this.logoColor = AppTheme.accentGreen,
  });

  final String title;
  final String subtitle;
  final Color logoColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMedium,
        vertical: AppTheme.spacingMedium,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppTheme.fontSizeXLarge,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXSmall),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: AppTheme.fontSizeMedium - 2,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          _KomaLogo(color: logoColor),
        ],
      ),
    );
  }
}
