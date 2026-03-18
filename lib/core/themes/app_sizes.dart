import 'package:flutter/material.dart';

/// Design system size constants optimized for tablet landscape orientation
/// Based on 8dp grid system as per the design specification
/// All interactive targets minimum 48x48dp for touch accessibility
class AppSizes {
  // Prevents instantiation and extension
  AppSizes._();

  // ============================================================
  // SPACING SYSTEM (8dp base unit)
  // ============================================================

  /// Base spacing unit
  static const double unit = 8.0;

  /// Extra small spacing - 4dp
  static const double spacingXs = 4.0;

  /// Small spacing - 8dp
  static const double spacingSm = 8.0;

  /// Medium spacing - 16dp
  static const double spacingMd = 16.0;

  /// Large spacing - 24dp
  static const double spacingLg = 24.0;

  /// Extra large spacing - 32dp
  static const double spacingXl = 32.0;

  /// Page margin on all sides - 24dp
  static const double pageMargin = 24.0;

  /// Card internal padding - 16dp
  static const double cardPadding = 16.0;

  /// Content gaps within cards - 12dp
  static const double cardContentGap = 12.0;

  /// Section gaps - 24dp
  static const double sectionGap = 24.0;

  // ============================================================
  // LEGACY SIZES (for backward compatibility)
  // ============================================================

  /// Legacy margin - maps to page margin
  static const double margin = 18;

  /// Legacy padding - maps to medium spacing
  static const double padding = 18;

  /// Legacy radius - maps to default border radius
  static const double radius = 8;

  // ============================================================
  // BORDER RADIUS
  // ============================================================

  /// Default border radius - 8dp
  static const double radiusDefault = 8.0;

  /// Small border radius - 4dp
  static const double radiusSm = 4.0;

  /// Card border radius - 16dp as per design spec
  static const double radiusCard = 16.0;

  /// Button border radius - 12dp as per design spec
  static const double radiusButton = 12.0;

  /// Pill/chip border radius - 18dp (for fully rounded pills)
  static const double radiusPill = 18.0;

  // ============================================================
  // TOUCH TARGETS (minimum 48dp as per accessibility spec)
  // ============================================================

  /// Minimum touch target height
  static const double touchTargetMin = 48.0;

  /// Minimum button height
  static const double buttonHeightMin = 48.0;

  /// Icon button size
  static const double iconButtonSize = 48.0;

  /// Large icon button size
  static const double iconButtonSizeLg = 56.0;

  // ============================================================
  // ICON SIZES
  // ============================================================

  /// Default icon size for navigation and card actions
  static const double iconDefault = 24.0;

  /// Small icon size for inline or dense-list contexts
  static const double iconSm = 20.0;

  /// Large icon size for metric cards and prominent elements
  static const double iconLg = 32.0;

  /// Extra large icon size
  static const double iconXl = 48.0;

  // ============================================================
  // SIDEBAR LAYOUT (tablet landscape)
  // ============================================================

  /// Left sidebar width - 260-280dp as per spec
  static const double sidebarWidth = 272.0;

  /// Sidebar padding
  static const double sidebarPadding = 16.0;

  /// Sidebar item height
  static const double sidebarItemHeight = 48.0;

  // ============================================================
  // NAVIGATION PILLS
  // ============================================================

  /// Pill/chip height - 36dp as per spec
  static const double pillHeight = 36.0;

  /// Pill horizontal padding - 16dp
  static const double pillPaddingH = 16.0;

  /// Pill vertical padding - 8dp
  static const double pillPaddingV = 8.0;

  // ============================================================
  // SCREEN DIMENSIONS
  // ============================================================

  /// Minimum tablet width in landscape
  static const double tabletMinWidth = 1024.0;

  /// Minimum tablet height in landscape
  static const double tabletMinHeight = 768.0;

  /// Get screen size
  static Size size(BuildContext context) => MediaQuery.sizeOf(context);

  /// Get screen width
  static double screenWidth(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  /// Get screen height
  static double screenHeight(BuildContext context) =>
      MediaQuery.sizeOf(context).height;

  /// Get available width excluding sidebar
  static double mainContentWidth(BuildContext context) =>
      screenWidth(context) - sidebarWidth;

  /// App bar height
  static double appBarHeight() => AppBar().preferredSize.height;

  /// Get view padding (notch, etc.)
  static EdgeInsets viewPadding(BuildContext context) =>
      MediaQuery.of(context).padding;

  // ============================================================
  // HELPER METHODS
  // ============================================================

  /// Check if device is tablet in landscape orientation
  static bool isTabletLandscape(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return size.width >= tabletMinWidth && size.height < tabletMinWidth;
  }

  /// Get responsive spacing based on screen width
  static double responsiveSpacing(BuildContext context) {
    final width = screenWidth(context);
    if (width >= 1200) return spacingXl;
    if (width >= 1024) return spacingLg;
    return spacingMd;
  }

  /// Card width for grid layouts
  static double cardWidth(BuildContext context, {int crossAxisCount = 4}) {
    final availableWidth = mainContentWidth(context) - (pageMargin * 2);
    final gap = cardContentGap;
    return (availableWidth - (gap * (crossAxisCount - 1))) / crossAxisCount;
  }
}
