import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../navigation/navigation_helper.dart';

/// Spójny komponent bottom navigation dla całej aplikacji
/// Automatycznie obsługuje nawigację między głównymi ekranami
class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({
    super.key,
    required this.selectedIndex,
    this.onTap,
    this.height = 56,
  });

  final int selectedIndex;
  final void Function(int)? onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _handleTap(context, 0),
                child: _buildNavigationItem(
                  icon: Icons.calendar_month_outlined,
                  tooltip: l10n.scheduleTooltip,
                  isSelected: selectedIndex == 0,
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => _handleTap(context, 1),
                child: _buildNavigationItem(
                  icon: Icons.book_outlined,
                  tooltip: l10n.knowledgeBaseTooltip,
                  isSelected: selectedIndex == 1,
                ),
              ),
            ),
            Expanded(
              child: _buildDropdownNavigationItem(
                icon: Icons.more_horiz,
                tooltip: l10n.externalLinks,
                isSelected: selectedIndex == 2,
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => _handleTap(context, 3),
                child: _buildNavigationItemWithBadge(
                  icon: Icons.notifications_outlined,
                  tooltip: l10n.notificationsTooltip,
                  isSelected: selectedIndex == 3,
                  badgeCount: 0,
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => _handleTap(context, 4),
                child: _buildNavigationItem(
                  icon: Icons.settings_outlined,
                  tooltip: l10n.settingsTooltip,
                  isSelected: selectedIndex == 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap(BuildContext context, int index) {
    if (onTap != null) {
      onTap!(index);
    } else {
      NavigationHelper.navigateFromBottomNav(
        context,
        index,
        selectedIndex,
      );
    }
  }

  Widget _buildNavigationItem({
    required IconData icon,
    required String tooltip,
    required bool isSelected,
  }) {
    return Tooltip(
      message: tooltip,
      child: _NavigationIcon(
        icon: icon, 
        isSelected: isSelected,
        height: height,
      ),
    );
  }

  Widget _buildNavigationItemWithBadge({
    required IconData icon,
    required String tooltip,
    required bool isSelected,
    required int badgeCount,
  }) {
    return Tooltip(
      message: tooltip,
      child: _NavigationIconWithBadge(
        icon: icon,
        isSelected: isSelected,
        badgeCount: badgeCount,
        height: height,
      ),
    );
  }

  Widget _buildDropdownNavigationItem({
    required IconData icon,
    required String tooltip,
    required bool isSelected,
  }) {
    return Tooltip(
      message: tooltip,
      child: _DropdownNavigationIcon(
        icon: icon,
        isSelected: isSelected,
        height: height,
      ),
    );
  }
}

/// Widget ikony nawigacji - wydzielony dla lepszej wydajności
class _NavigationIcon extends StatelessWidget {
  const _NavigationIcon({
    required this.icon, 
    required this.isSelected,
    required this.height,
  });

  final IconData icon;
  final bool isSelected;
  final double height;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxSize = constraints.maxWidth;
        return Container(
          width: boxSize,
          height: boxSize-12,
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
          ),
          child: Icon(
            icon,
            size: 32,
            color: isSelected ? AppTheme.backgroundWhite : AppTheme.textPrimary,
          ),
        );
      },
    );
  }
}

/// Widget ikony nawigacji z badge'm - wydzielony dla lepszej wydajności
class _NavigationIconWithBadge extends StatelessWidget {
  const _NavigationIconWithBadge({
    required this.icon,
    required this.isSelected,
    required this.badgeCount,
    required this.height,
  });

  final IconData icon;
  final bool isSelected;
  final int badgeCount;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _NavigationIcon(icon: icon, isSelected: isSelected, height: height),
        if (badgeCount > 0)
          Positioned(
            right: -2,
            top: -2,
            child: _NotificationBadge(count: badgeCount),
          ),
      ],
    );
  }
}

/// Badge z liczbą powiadomień
class _NotificationBadge extends StatelessWidget {
  const _NotificationBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final displayCount = count > 99 ? '99+' : count.toString();

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        color: AppTheme.errorRed,
        shape: BoxShape.circle,
      ),
      constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
      child: Text(
        displayCount,
        style: const TextStyle(
          color: AppTheme.backgroundWhite,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Widget ikony z dropdown menu dla zewnętrznych linków
class _DropdownNavigationIcon extends StatelessWidget {
  const _DropdownNavigationIcon({
    required this.icon,
    required this.isSelected,
    required this.height,
  });

  final IconData icon;
  final bool isSelected;
  final double height;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: LayoutBuilder(
        builder: (context, constraints) {
          final boxSize = constraints.maxWidth;
          return Container(
            width: boxSize,
            height: boxSize,
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
            ),
            child: Icon(
              icon,
              color: isSelected ? AppTheme.backgroundWhite : AppTheme.textPrimary,
              size: 32,
            ),
          );
        },
      ),
      onSelected: (value) {
        switch (value) {
          case 'shop':
            NavigationHelper.launchExternalUrl(
              context,
              'https://sklep.koma.pl/',
              AppLocalizations.of(context)!.shop,
            );
            break;
          case 'bok':
            NavigationHelper.launchExternalUrl(
              context,
              'https://bok.koma.pl/',
              AppLocalizations.of(context)!.bokPortal,
            );
            break;
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'shop',
          child: Row(
            children: [
              Icon(Icons.shopping_bag_outlined, color: Colors.grey.shade700),
              const SizedBox(width: 12),
              Text(AppLocalizations.of(context)!.shop),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'bok',
          child: Row(
            children: [
              Icon(Icons.language, color: Colors.grey.shade700),
              const SizedBox(width: 12),
              Text(AppLocalizations.of(context)!.bokPortal),
            ],
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 8,
      color: Colors.white,
    );
  }
}
