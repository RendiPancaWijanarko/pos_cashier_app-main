import 'package:flutter/material.dart';

import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_sizes.dart';
import '../../../core/themes/app_typography.dart';

/// Sidebar navigation item data
class DesignNavItem {
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final dynamic route;

  const DesignNavItem({
    required this.label,
    required this.icon,
    this.activeIcon,
    this.route,
  });
}

/// Left sidebar for tablet landscape orientation
/// Contains: app logo, cashier profile, main navigation, session summary
class DesignSidebar extends StatelessWidget {
  /// Navigation items
  final List<DesignNavItem> navItems;

  /// Currently selected navigation index
  final int selectedIndex;

  /// Callback when navigation item is selected
  final Function(int)? onItemSelected;

  /// Optional app logo widget
  final Widget? logo;

  /// Optional cashier profile widget
  final Widget? profile;

  /// Optional session summary widget at bottom
  final Widget? sessionSummary;

  /// Sidebar width
  final double width;

  const DesignSidebar({
    super.key,
    required this.navItems,
    this.selectedIndex = 0,
    this.onItemSelected,
    this.logo,
    this.profile,
    this.sessionSummary,
    this.width = AppSizes.sidebarWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: AppColors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Logo section
            if (logo != null)
              Padding(
                padding: const EdgeInsets.all(AppSizes.sidebarPadding),
                child: logo,
              ),

            // Navigation items
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spacingMd,
                  vertical: AppSizes.spacingSm,
                ),
                itemCount: navItems.length,
                itemBuilder: (context, index) {
                  final item = navItems[index];
                  final isSelected = selectedIndex == index;

                  return _NavItemTile(
                    item: item,
                    isSelected: isSelected,
                    onTap: () => onItemSelected?.call(index),
                  );
                },
              ),
            ),

            // Session summary at bottom
            if (sessionSummary != null) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(AppSizes.sidebarPadding),
                child: sessionSummary,
              ),
            ],

            // Profile at very bottom
            if (profile != null) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(AppSizes.sidebarPadding),
                child: profile,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NavItemTile extends StatelessWidget {
  final DesignNavItem item;
  final bool isSelected;
  final VoidCallback? onTap;

  const _NavItemTile({
    required this.item,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spacingXs),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: AppSizes.sidebarItemHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingMd),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryLightest
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                  size: AppSizes.iconDefault,
                  color: isSelected ? AppColors.primary : AppColors.textMuted,
                ),
                const SizedBox(width: AppSizes.spacingMd),
                Text(
                  item.label,
                  style: isSelected
                      ? AppTypography.navItemActive
                      : AppTypography.navItem,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact sidebar variant - just navigation icons with tooltips
class DesignSidebarCompact extends StatelessWidget {
  final List<DesignNavItem> navItems;
  final int selectedIndex;
  final Function(int)? onItemSelected;
  final Widget? header;
  final Widget? footer;

  const DesignSidebarCompact({
    super.key,
    required this.navItems,
    this.selectedIndex = 0,
    this.onItemSelected,
    this.header,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      color: AppColors.white,
      child: SafeArea(
        child: Column(
          children: [
            if (header case final Widget h) h,

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSizes.spacingSm,
                ),
                itemCount: navItems.length,
                itemBuilder: (context, index) {
                  final item = navItems[index];
                  final isSelected = selectedIndex == index;

                  return _CompactNavItem(
                    item: item,
                    isSelected: isSelected,
                    onTap: () => onItemSelected?.call(index),
                  );
                },
              ),
            ),

            if (footer case final Widget f) f,
          ],
        ),
      ),
    );
  }
}

class _CompactNavItem extends StatelessWidget {
  final DesignNavItem item;
  final bool isSelected;
  final VoidCallback? onTap;

  const _CompactNavItem({
    required this.item,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingSm,
        vertical: AppSizes.spacingXs,
      ),
      child: Tooltip(
        message: item.label,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: AppSizes.iconButtonSize,
              height: AppSizes.iconButtonSize,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryLightest
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
              ),
              child: Icon(
                isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                size: AppSizes.iconDefault,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
