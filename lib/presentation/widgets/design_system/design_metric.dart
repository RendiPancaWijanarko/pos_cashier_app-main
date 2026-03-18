import 'package:flutter/material.dart';

import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_sizes.dart';
import '../../../core/themes/app_typography.dart';

/// Design system metric card - bold metric callout style
/// Large number, small muted label beneath, accent icon to the left
/// Used for: daily revenue, items sold, open orders, average transaction value
class DesignMetricCard extends StatelessWidget {
  /// Metric value/number
  final String value;

  /// Metric label
  final String label;

  /// Icon to display
  final IconData? icon;

  /// Optional percentage change indicator
  final double? changePercent;

  /// Whether change is positive (true) or negative (false)
  final bool? isPositive;

  /// Optional callback when card is tapped
  final VoidCallback? onTap;

  /// Custom value color
  final Color? valueColor;

  const DesignMetricCard({
    super.key,
    required this.value,
    required this.label,
    this.icon,
    this.changePercent,
    this.isPositive,
    this.onTap,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Row(
      children: [
        // Icon container with orange tint background
        if (icon != null)
          Container(
            width: 48,
            height: 48,
            margin: const EdgeInsets.only(right: AppSizes.cardContentGap),
            decoration: BoxDecoration(
              color: AppColors.primaryLightest,
              borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
            ),
            child: Icon(
              icon,
              size: AppSizes.iconDefault,
              color: AppColors.primary,
            ),
          ),

        // Value and label
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Metric value
              Text(
                value,
                style: AppTypography.metricValue.copyWith(
                  color: valueColor ?? AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: AppSizes.spacingXs),

              // Metric label and change indicator
              Row(
                children: [
                  Text(label, style: AppTypography.metricLabel),
                  if (changePercent != null) ...[
                    const SizedBox(width: AppSizes.spacingSm),
                    _buildChangeIndicator(),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSizes.cardPadding),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusCard),
            border: Border.all(color: AppColors.cardBorder, width: 1),
          ),
          child: content,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppSizes.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: content,
    );
  }

  Widget _buildChangeIndicator() {
    final isPositiveChange = isPositive ?? changePercent! >= 0;
    final color = isPositiveChange ? AppColors.success : AppColors.destructive;
    final icon = isPositiveChange
        ? Icons.arrow_upward_rounded
        : Icons.arrow_downward_rounded;
    final sign = isPositiveChange ? '+' : '';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 2),
        Text(
          '$sign${changePercent!.toStringAsFixed(1)}%',
          style: AppTypography.secondaryLabel.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Compact metric display - used in lists or smaller spaces
class DesignMetricCompact extends StatelessWidget {
  final String value;
  final String label;
  final IconData? icon;
  final Color? iconColor;

  const DesignMetricCompact({
    super.key,
    required this.value,
    required this.label,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: AppSizes.iconSm,
            color: iconColor ?? AppColors.primary,
          ),
          const SizedBox(width: AppSizes.spacingXs),
        ],
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: AppTypography.dataValue.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              label,
              style: AppTypography.secondaryLabel.copyWith(fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }
}

/// Status badge - ALL CAPS for quick scanning
/// Used for: ON, OFF, VOID, ACTIVE, PENDING
class DesignStatusBadge extends StatelessWidget {
  final String text;
  final DesignBadgeVariant variant;
  final IconData? icon;

  const DesignStatusBadge({
    super.key,
    required this.text,
    this.variant = DesignBadgeVariant.primary,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (variant) {
      case DesignBadgeVariant.primary:
        backgroundColor = AppColors.primary;
        textColor = AppColors.white;
        break;
      case DesignBadgeVariant.success:
        backgroundColor = AppColors.success;
        textColor = AppColors.white;
        break;
      case DesignBadgeVariant.warning:
        backgroundColor = AppColors.warning;
        textColor = AppColors.white;
        break;
      case DesignBadgeVariant.destructive:
        backgroundColor = AppColors.destructive;
        textColor = AppColors.white;
        break;
      case DesignBadgeVariant.neutral:
        backgroundColor = AppColors.surfaceLight;
        textColor = AppColors.textSecondary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingSm,
        vertical: AppSizes.spacingXs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: AppSizes.spacingXs),
          ],
          Text(
            text.toUpperCase(),
            style: AppTypography.statusBadge.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}

enum DesignBadgeVariant { primary, success, warning, destructive, neutral }
