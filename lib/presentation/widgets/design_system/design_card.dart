import 'package:flutter/material.dart';

import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_sizes.dart';
import '../../../core/themes/app_typography.dart';

/// Design system card component - primary container unit throughout the app
/// White background, 16dp border radius, subtle border
/// Active/selected states use orange primary with white text
class DesignCard extends StatelessWidget {
  /// Card content
  final Widget child;

  /// Whether this card is in active/selected state
  final bool isActive;

  /// Whether this card is clickable
  final bool isClickable;

  /// Optional onTap callback
  final VoidCallback? onTap;

  /// Optional padding override
  final EdgeInsetsGeometry? padding;

  /// Optional width constraint
  final double? width;

  /// Optional height constraint
  final double? height;

  /// Optional background color override
  final Color? backgroundColor;

  /// Optional border radius override
  final BorderRadius? borderRadius;

  /// Whether to show image overlay gradient
  final bool showImageOverlay;

  const DesignCard({
    super.key,
    required this.child,
    this.isActive = false,
    this.isClickable = false,
    this.onTap,
    this.padding,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderRadius,
    this.showImageOverlay = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isActive
        ? AppColors.primary
        : (backgroundColor ?? AppColors.white);

    Widget cardContent = Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(AppSizes.cardPadding),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius:
            borderRadius ?? BorderRadius.circular(AppSizes.radiusCard),
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.cardBorder,
          width: 1,
        ),
      ),
      child: showImageOverlay
          ? Stack(
              children: [
                child,
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: AppColors.cardImageOverlay,
                    ),
                  ),
                ),
              ],
            )
          : child,
    );

    // Apply text color transformation for active state
    if (isActive) {
      cardContent = ColorFiltered(
        colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
        child: cardContent,
      );
    }

    if (isClickable && onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius:
            borderRadius ?? BorderRadius.circular(AppSizes.radiusCard),
        child: InkWell(
          onTap: onTap,
          borderRadius:
              borderRadius ?? BorderRadius.circular(AppSizes.radiusCard),
          splashFactory: InkRipple.splashFactory,
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }
}

/// Simplified card with only content - no active state handling
/// Use this when you need complete control over the card appearance
class DesignCardSimple extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool showImageOverlay;

  const DesignCardSimple({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderRadius,
    this.onTap,
    this.showImageOverlay = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(AppSizes.cardPadding),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.white,
        borderRadius:
            borderRadius ?? BorderRadius.circular(AppSizes.radiusCard),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: showImageOverlay
          ? Stack(
              children: [
                child,
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      gradient: AppColors.cardImageOverlay,
                    ),
                  ),
                ),
              ],
            )
          : child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius:
            borderRadius ?? BorderRadius.circular(AppSizes.radiusCard),
        child: InkWell(
          onTap: onTap,
          borderRadius:
              borderRadius ?? BorderRadius.circular(AppSizes.radiusCard),
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }
}

/// Section card with title - used for grouping related content
class DesignSectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;

  const DesignSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.cardPadding,
              AppSizes.cardPadding,
              AppSizes.cardPadding,
              AppSizes.spacingSm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: AppTypography.cardTitle),
                if (trailing case final Widget t) t,
              ],
            ),
          ),
          Padding(
            padding:
                padding ??
                const EdgeInsets.fromLTRB(
                  AppSizes.cardPadding,
                  0,
                  AppSizes.cardPadding,
                  AppSizes.cardPadding,
                ),
            child: child,
          ),
        ],
      ),
    );
  }
}
