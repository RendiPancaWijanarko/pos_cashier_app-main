import 'package:flutter/material.dart';

import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_sizes.dart';
import '../../../core/themes/app_typography.dart';

/// Design system pill/filter tab - pill-shaped category selector
/// Active: orange primary fill with white text
/// Inactive: Slate 100 surface with Slate 500 text
class DesignPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final IconData? icon;

  const DesignPill({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: AppSizes.pillHeight,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.pillPaddingH),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppSizes.radiusPill),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.surfaceLight,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: AppSizes.iconSm,
                color: isSelected ? AppColors.white : AppColors.textSecondary,
              ),
              const SizedBox(width: AppSizes.spacingXs),
            ],
            Text(
              label,
              style: isSelected
                  ? AppTypography.pillActive
                  : AppTypography.pillInactive,
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal scrollable pill row for category filters
/// Only scrolls horizontally if there are more than 6 items
class DesignPillRow extends StatelessWidget {
  final List<DesignPillItem> items;
  final int? selectedIndex;
  final Function(int)? onSelected;

  const DesignPillRow({
    super.key,
    required this.items,
    this.selectedIndex,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final shouldScroll = items.length > 6;

    if (shouldScroll) {
      return SizedBox(
        height: AppSizes.pillHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.pageMargin),
          itemCount: items.length,
          separatorBuilder: (context, index) =>
              const SizedBox(width: AppSizes.spacingSm),
          itemBuilder: (context, index) {
            final item = items[index];
            return DesignPill(
              label: item.label,
              icon: item.icon,
              isSelected: selectedIndex == index,
              onTap: () => onSelected?.call(index),
            );
          },
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.pageMargin),
      child: Row(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSizes.spacingSm),
            DesignPill(
              label: items[i].label,
              icon: items[i].icon,
              isSelected: selectedIndex == i,
              onTap: () => onSelected?.call(i),
            ),
          ],
        ],
      ),
    );
  }
}

/// Item data for DesignPillRow
class DesignPillItem {
  final String label;
  final IconData? icon;
  final dynamic value;

  const DesignPillItem({required this.label, this.icon, this.value});
}

/// Filter chip variant - more compact than DesignPill
/// Used for dense filter options
class DesignFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final Widget? trailing;

  const DesignFilterChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacingMd,
          vertical: AppSizes.spacingSm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.surfaceLight,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.white : AppColors.textSecondary,
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSizes.spacingXs),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
