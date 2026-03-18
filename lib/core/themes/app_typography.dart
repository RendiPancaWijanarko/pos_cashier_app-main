import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Design system typography using system font (Roboto on Android, San Francisco on iOS)
/// Strict type scale for tablet landscape readability at arm's length
/// All sizes use sp units for accessibility (system font size scaling)
///
/// NOTE: Previously used GoogleFonts.inter but changed to system fonts
/// to avoid network dependency on app startup (offline-first requirement)
class AppTypography {
  // Prevents instantiation and extension
  AppTypography._();

  // ============================================================
  // FONT FAMILY
  // ============================================================

  /// Primary font family - system default (Roboto on Android, San Francisco on iOS)
  /// This ensures the app works completely offline without network font downloads
  static String? get fontFamily => null; // null uses system default

  /// Secondary font family - same as primary for consistency
  static String? get fontFamilySecondary => null;

  // ============================================================
  // TEXT STYLES - Using system font
  // ============================================================

  /// Screen titles and section headers - 28sp, weight 700
  static TextStyle get screenTitle => TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  /// Card titles and room/category labels - 20sp, weight 600
  static TextStyle get cardTitle => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  /// Primary data values (totals, quantities, prices) - 18sp, weight 700
  /// Scannable at a glance for key figures
  static TextStyle get dataValue => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  /// Body text and descriptions - 15sp, weight 400, line height 1.6
  static TextStyle get bodyText => TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.textPrimary,
  );

  /// Secondary/muted labels - 13sp, weight 400, color Slate 500
  static TextStyle get secondaryLabel => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  /// Button text - 15sp, weight 600
  static TextStyle get buttonText => TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.white,
  );

  /// Small button text - 13sp, weight 600
  static TextStyle get buttonTextSmall => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.white,
  );

  // ============================================================
  // SPECIALTY TEXT STYLES
  // ============================================================

  /// Metric large number - 28sp, weight 700
  static TextStyle get metricValue => TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  /// Metric label - 13sp, weight 400, secondary color
  static TextStyle get metricLabel => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  /// Status badge text - ALL CAPS, 11sp, weight 600
  static TextStyle get statusBadge => TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.0,
    letterSpacing: 0.5,
    color: AppColors.white,
  );

  /// Price text - 18sp, weight 700
  static TextStyle get priceText => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.4,
    color: AppColors.primary,
  );

  /// Price text large - 24sp, weight 700
  static TextStyle get priceTextLarge => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: AppColors.primary,
  );

  // ============================================================
  // TEXT STYLES FOR SPECIFIC COLORS
  // ============================================================

  /// Primary text on primary background
  static TextStyle get onPrimary => TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.white,
  );

  /// Primary text on light orange background
  static TextStyle get onPrimaryLight => TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.primaryDarkest,
  );

  /// Success text - green
  static TextStyle get successText => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.success,
  );

  /// Destructive text - red
  static TextStyle get destructiveText => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.destructive,
  );

  /// Warning text - amber
  static TextStyle get warningText => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.warning,
  );

  // ============================================================
  // NAVIGATION TEXT STYLES
  // ============================================================

  /// Navigation item - 15sp, weight 500
  static TextStyle get navItem => TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  /// Navigation item active - 15sp, weight 600, primary color
  static TextStyle get navItemActive => TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.primary,
  );

  /// Sidebar title - 13sp, weight 600, uppercase
  static TextStyle get sidebarTitle => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.5,
    color: AppColors.textMuted,
  );

  // ============================================================
  // INPUT TEXT STYLES
  // ============================================================

  /// Text field input - 15sp, weight 400
  static TextStyle get textFieldInput => TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  /// Text field hint - 15sp, weight 400, muted color
  static TextStyle get textFieldHint => TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textMuted,
  );

  /// Text field label - 13sp, weight 500
  static TextStyle get textFieldLabel => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  // ============================================================
  // PILL/CHIP TEXT STYLES
  // ============================================================

  /// Pill inactive - 13sp, weight 500
  static TextStyle get pillInactive => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.2,
    color: AppColors.textSecondary,
  );

  /// Pill active - 13sp, weight 600
  static TextStyle get pillActive => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.white,
  );

  // ============================================================
  // TEXT THEME FOR MATERIAL
  // ============================================================

  /// Generate complete TextTheme for Material theme
  static TextTheme get textTheme => TextTheme(
    displayLarge: screenTitle,
    displayMedium: cardTitle,
    displaySmall: dataValue,
    headlineLarge: screenTitle,
    headlineMedium: cardTitle,
    headlineSmall: dataValue,
    titleLarge: cardTitle,
    titleMedium: bodyText.copyWith(fontWeight: FontWeight.w600),
    titleSmall: secondaryLabel,
    bodyLarge: bodyText,
    bodyMedium: bodyText,
    bodySmall: secondaryLabel,
    labelLarge: buttonText,
    labelMedium: buttonTextSmall,
    labelSmall: secondaryLabel,
  );
}
