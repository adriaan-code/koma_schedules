import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../config/app_theme.dart';

/// Spójny AppBar dla całej aplikacji
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.showBackButton = true,
    this.onBackPressed,
    this.actions,
    this.showKomaLogo = true,
  });
  final String? title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool showKomaLogo;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.backgroundWhite,
      elevation: 0,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppTheme.textBlack),
              tooltip: AppLocalizations.of(context)!.back,
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      title: title != null
          ? Text(
              title!,
              style: const TextStyle(
                color: AppTheme.textBlack,
                fontSize: AppTheme.fontSizeMedium,
                fontWeight: FontWeight.normal,
              ),
            )
          : null,
      actions:
          actions ??
          (showKomaLogo
              ? [
                  Padding(
                    padding: AppTheme.paddingHorizontal,
                    child: Image.asset(
                      'assets/img/logo.png',
                      width: AppTheme.iconSizeXLarge,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback jeśli logo nie istnieje
                        return Container(
                          width: AppTheme.iconSizeXLarge,
                          height: AppTheme.iconSizeXLarge,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue,
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                          ),
                        );
                      },
                    ),
                  ),
                ]
              : null),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
