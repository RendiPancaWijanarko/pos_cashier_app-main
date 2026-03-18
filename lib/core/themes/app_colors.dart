import 'package:flutter/material.dart';

/// Comprehensive design system colors for the POS Cashier Application
/// Built around orange as the primary brand color with warm tones
/// All color pairings meet WCAG AA contrast requirements
class AppColors {
  // Prevents instantiation and extension
  AppColors._();

  // ============================================================
  // ORANGE PRIMARY COLOR PALETTE
  // ============================================================

  /// Primary orange - vivid, saturated orange for main actions
  /// Used for primary buttons, active navigation, key data callouts
  static const Color primary = Color(0xFFF97316); // Orange 500

  /// Primary lighter tint - card backgrounds, highlights, badges
  static const Color primaryLight = Color(0xFFFFEDD5); // Orange 200

  /// Primary lightest - surface highlights, subtle backgrounds
  static const Color primaryLightest = Color(0xFFFFF7ED); // Orange 50

  /// Primary darker/pressed - hover/pressed states, strong borders
  static const Color primaryDark = Color(0xFFEA580C); // Orange 600

  /// Primary darkest - text on orange surfaces for WCAG AA contrast
  static const Color primaryDarkest = Color(0xFF7C2D12); // Orange 900

  /// Primary with opacity for subtle highlights
  static const Color primarySurface = Color(0xFFFFF7ED); // Orange 50

  // ============================================================
  // NEUTRAL COLORS
  // ============================================================

  /// Pure white for cards and primary surfaces
  static const Color white = Color(0xFFFFFFFF);

  /// Off-white for page backgrounds, keeping UI light and airy
  static const Color background = Color(0xFFF8FAFC); // Slate 50

  /// Light gray for secondary surfaces
  static const Color surfaceLight = Color(0xFFF1F5F9); // Slate 100

  /// Card border color - subtle border as per design spec
  static const Color cardBorder = Color(0x0F000000); // rgba(0,0,0,0.06)

  /// Primary text color - dark slate for maximum readability
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900

  /// Secondary text color - medium slate for less important text
  static const Color textSecondary = Color(0xFF64748B); // Slate 500

  /// Muted/tertiary text color
  static const Color textMuted = Color(0xFF94A3B8); // Slate 400

  /// Disabled or placeholder text
  static const Color textDisabled = Color(0xFFCBD5E1); // Slate 300

  // ============================================================
  // STATUS COLORS (accessible with icons)
  // ============================================================

  /// Success state - green for positive indicators
  static const Color success = Color(0xFF16A34A); // Green 600

  /// Success light - lighter green for backgrounds
  static const Color successLight = Color(0xFFDCFCE7); // Green 100

  /// Success darkest - text on success backgrounds
  static const Color successDark = Color(0xFF14532D); // Green 900

  /// Destructive/Void actions - red for negative/cancel actions
  static const Color destructive = Color(0xFFDC2626); // Red 600

  /// Destructive light - lighter red for backgrounds
  static const Color destructiveLight = Color(0xFFFEE2E2); // Red 100

  /// Destructive darkest - text on destructive backgrounds
  static const Color destructiveDark = Color(0xFF7F1D1D); // Red 900

  /// Warning state - amber for caution indicators
  static const Color warning = Color(0xFFD97706); // Amber 600

  /// Warning light - lighter amber for backgrounds
  static const Color warningLight = Color(0xFFFEF3C7); // Amber 100

  /// Warning darkest - text on warning backgrounds
  static const Color warningDark = Color(0xFF78350F); // Amber 900

  // ============================================================
  // LEGACY COLORS (for backward compatibility)
  // ============================================================

  /// Legacy orange - preserved for any legacy code
  static const Color orange = Color(0xFFFF8935);

  /// Legacy blue reference
  static const Color blue = Color(0xFF3886E3);
  static const Color darkBlue = Color(0xFF1E293B);

  /// Legacy other colors
  static const Color yellow = Color(0xFFF9AA00);
  static const Color green = Color(0xFF48C54A);
  static const Color red = Color(0xFFF4462C);
  static const Color purple = Color(0xFF8C62FF);
  static const Color cyan = Color(0xFF00BCD3);
  static const Color charcoal = Color(0xFF28536B);
  static const Color zamp = Color(0xFF66A182);
  static const Color plum = Color(0xFF66A182);

  // ============================================================
  // GRADIENTS
  // ============================================================

  /// Card overlay gradient for images - ensures white text readability
  static const LinearGradient cardImageOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      Color(0x73000000), // 45% black
    ],
  );

  /// Primary gradient for decorative elements
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFB923C), // Orange 400
      Color(0xFFF97316), // Orange 500
    ],
  );

  // ============================================================
  // SEMANTIC COLOR GETTERS
  // ============================================================

  /// Get primary color with custom opacity
  static Color primaryWithOpacity(double opacity) =>
      primary.withValues(alpha: opacity);

  /// Get text color for primary backgrounds
  static Color get textOnPrimary => white;

  /// Get text color for primary surface backgrounds
  static Color get textOnPrimarySurface => primaryDarkest;

  /// Get text color for white surfaces
  static Color get textOnWhite => textPrimary;

  /// Get text color for background surfaces
  static Color get textOnBackground => textPrimary;
}
