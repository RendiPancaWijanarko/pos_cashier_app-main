import 'package:flutter/material.dart';

import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_sizes.dart';
import '../../../core/themes/app_typography.dart';

/// Design system button hierarchy
/// Three tiers: Primary, Secondary, Tertiary/Ghost
/// All buttons have minimum 48dp height for touch accessibility
enum DesignButtonStyle { primary, secondary, tertiary, icon }

/// Primary button - orange fill, white text
/// Used for: confirm order, complete payment, add to cart
class DesignButton extends StatefulWidget {
  /// Button label text
  final String? text;

  /// Button content (alternative to text)
  final Widget? child;

  /// Button style variant
  final DesignButtonStyle style;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Whether button is enabled
  final bool enabled;

  /// Optional icon to display
  final IconData? icon;

  /// Icon position
  final bool iconLeading;

  /// Optional width constraint
  final double? width;

  /// Optional height override
  final double? height;

  /// Loading state
  final bool isLoading;

  const DesignButton({
    super.key,
    this.text,
    this.child,
    this.style = DesignButtonStyle.primary,
    this.onPressed,
    this.enabled = true,
    this.icon,
    this.iconLeading = true,
    this.width,
    this.height,
    this.isLoading = false,
  });

  @override
  State<DesignButton> createState() => _DesignButtonState();
}

class _DesignButtonState extends State<DesignButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.enabled && !widget.isLoading) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enabled && !widget.isLoading) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.enabled && !widget.isLoading) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) =>
          Transform.scale(scale: _scaleAnimation.value, child: child),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.enabled && !widget.isLoading ? widget.onPressed : null,
        child: _buildButton(),
      ),
    );
  }

  Widget _buildButton() {
    final height = widget.height ?? AppSizes.buttonHeightMin;
    final isDisabled = !widget.enabled;
    final isPrimary = widget.style == DesignButtonStyle.primary;
    final isSecondary = widget.style == DesignButtonStyle.secondary;
    final isTertiary = widget.style == DesignButtonStyle.tertiary;
    final isIcon = widget.style == DesignButtonStyle.icon;

    // Determine colors based on style and state
    Color backgroundColor;
    Color foregroundColor;
    Color borderColor;

    if (isDisabled) {
      backgroundColor = isTertiary || isIcon
          ? Colors.transparent
          : AppColors.surfaceLight;
      foregroundColor = AppColors.textDisabled;
      borderColor = Colors.transparent;
    } else if (isPrimary) {
      backgroundColor = _isPressed ? AppColors.primaryDark : AppColors.primary;
      foregroundColor = AppColors.white;
      borderColor = Colors.transparent;
    } else if (isSecondary) {
      backgroundColor = _isPressed
          ? AppColors.primaryLightest
          : AppColors.white;
      foregroundColor = AppColors.primary;
      borderColor = AppColors.primary;
    } else if (isIcon) {
      backgroundColor = _isPressed
          ? AppColors.primaryLight
          : AppColors.primaryLightest;
      foregroundColor = AppColors.primary;
      borderColor = Colors.transparent;
    } else {
      // Tertiary
      backgroundColor = Colors.transparent;
      foregroundColor = AppColors.textSecondary;
      borderColor = Colors.transparent;
    }

    Widget content;
    if (widget.isLoading) {
      content = SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
        ),
      );
    } else if (widget.child != null) {
      content = widget.child!;
    } else {
      final hasIcon = widget.icon != null;
      final textWidget = Text(
        widget.text ?? '',
        style:
            (isIcon ? AppTypography.secondaryLabel : AppTypography.buttonText)
                .copyWith(color: foregroundColor),
      );

      if (hasIcon) {
        final iconWidget = Icon(
          widget.icon,
          size: isIcon ? AppSizes.iconSm : AppSizes.iconDefault,
          color: foregroundColor,
        );

        content = widget.iconLeading || isIcon
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isIcon) iconWidget,
                  if (!isIcon) const SizedBox(width: AppSizes.spacingSm),
                  if (!isIcon) textWidget,
                  if (isIcon) iconWidget,
                ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isIcon) textWidget,
                  if (!isIcon) const SizedBox(width: AppSizes.spacingSm),
                  iconWidget,
                ],
              );
      } else {
        content = textWidget;
      }
    }

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 100),
      opacity: isDisabled ? 0.5 : 1.0,
      child: Container(
        width: widget.width,
        height: isIcon ? AppSizes.iconButtonSize : height,
        padding: isIcon
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: AppSizes.spacingLg),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(
            isIcon ? AppSizes.radiusPill : AppSizes.radiusButton,
          ),
          border: Border.all(color: borderColor, width: isSecondary ? 1.5 : 1),
        ),
        child: Center(child: content),
      ),
    );
  }
}

/// Icon-only button with toggle capability
/// Uses orange tint background when inactive, orange fill when active
class DesignIconButton extends StatefulWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback? onPressed;
  final bool enabled;
  final double? size;
  final String? tooltip;

  const DesignIconButton({
    super.key,
    required this.icon,
    this.isActive = false,
    this.onPressed,
    this.enabled = true,
    this.size,
    this.tooltip,
  });

  @override
  State<DesignIconButton> createState() => _DesignIconButtonState();
}

class _DesignIconButtonState extends State<DesignIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final button = GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.enabled ? widget.onPressed : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnimation.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: widget.size ?? AppSizes.iconButtonSize,
          height: widget.size ?? AppSizes.iconButtonSize,
          decoration: BoxDecoration(
            color: widget.isActive
                ? AppColors.primary
                : AppColors.primaryLightest,
            shape: BoxShape.circle,
          ),
          child: Icon(
            widget.icon,
            size: AppSizes.iconDefault,
            color: widget.isActive ? AppColors.white : AppColors.primary,
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: button);
    }

    return button;
  }
}
