import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_sizes.dart';
import 'app_typography.dart';

/// Complete application theme using the orange design system
/// Optimized for tablet landscape orientation
class AppTheme {
  // Make [AppTheme] to be singleton
  static final AppTheme _instance = AppTheme._();

  factory AppTheme() => _instance;

  AppTheme._();

  /// Initialize theme with optional customizations
  ThemeData init() {
    return _buildTheme();
  }

  /// Build the complete Material theme
  ThemeData _buildTheme() {
    // Create color scheme from orange primary
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: AppColors.primaryDarkest,
      secondary: AppColors.primaryDark,
      onSecondary: AppColors.white,
      secondaryContainer: AppColors.primaryLightest,
      onSecondaryContainer: AppColors.primaryDarkest,
      tertiary: AppColors.warning,
      onTertiary: AppColors.white,
      surface: AppColors.white,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.surfaceLight,
      surfaceContainerHigh: AppColors.background,
      surfaceContainer: AppColors.background,
      surfaceContainerLow: AppColors.background,
      surfaceContainerLowest: AppColors.white,
      error: AppColors.destructive,
      onError: AppColors.white,
      outline: AppColors.textMuted,
      outlineVariant: AppColors.surfaceLight,
      shadow: AppColors.textPrimary.withValues(alpha: 0.1),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,

      // Typography
      textTheme: _buildTextTheme(),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: AppSizes.pageMargin,
        titleTextStyle: AppTypography.screenTitle,
        iconTheme: IconThemeData(
          color: AppColors.textPrimary,
          size: AppSizes.iconDefault,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusCard),
          side: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          minimumSize: Size(0, AppSizes.buttonHeightMin),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacingLg,
            vertical: AppSizes.spacingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusButton),
          ),
          textStyle: AppTypography.buttonText,
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: Size(0, AppSizes.buttonHeightMin),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacingLg,
            vertical: AppSizes.spacingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusButton),
          ),
          side: BorderSide(color: AppColors.primary, width: 1.5),
          textStyle: AppTypography.buttonText.copyWith(
            color: AppColors.primary,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: Size(0, AppSizes.touchTargetMin),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacingMd,
            vertical: AppSizes.spacingSm,
          ),
          textStyle: AppTypography.buttonText.copyWith(
            color: AppColors.primary,
          ),
        ),
      ),

      // Icon Button Theme
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: Size(AppSizes.iconButtonSize, AppSizes.iconButtonSize),
          iconSize: AppSizes.iconDefault,
          foregroundColor: AppColors.textSecondary,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusButton),
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceLight,
        selectedColor: AppColors.primary,
        labelStyle: AppTypography.pillInactive,
        secondaryLabelStyle: AppTypography.pillActive,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.pillPaddingH,
          vertical: AppSizes.pillPaddingV,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusPill),
        ),
        side: BorderSide.none,
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacingMd,
          vertical: AppSizes.spacingMd,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
          borderSide: BorderSide(color: AppColors.surfaceLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
          borderSide: BorderSide(color: AppColors.surfaceLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
          borderSide: BorderSide(color: AppColors.destructive),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
          borderSide: BorderSide(color: AppColors.destructive, width: 2),
        ),
        labelStyle: AppTypography.textFieldLabel,
        hintStyle: AppTypography.textFieldHint,
        errorStyle: AppTypography.secondaryLabel.copyWith(
          color: AppColors.destructive,
        ),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.surfaceLight,
        thickness: 1,
        space: AppSizes.spacingMd,
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        ),
        titleTextStyle: AppTypography.cardTitle,
        contentTextStyle: AppTypography.bodyText,
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.white,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSizes.radiusCard),
            topRight: Radius.circular(AppSizes.radiusCard),
          ),
        ),
      ),

      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.primary,
        contentTextStyle: AppTypography.buttonText,
        actionTextColor: AppColors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
        ),
      ),

      // Navigation Rail Theme (for tablet sidebar)
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppColors.white,
        selectedIconTheme: IconThemeData(
          color: AppColors.primary,
          size: AppSizes.iconDefault,
        ),
        unselectedIconTheme: IconThemeData(
          color: AppColors.textMuted,
          size: AppSizes.iconDefault,
        ),
        selectedLabelTextStyle: AppTypography.navItemActive,
        unselectedLabelTextStyle: AppTypography.navItem,
        indicatorColor: AppColors.primaryLightest,
        elevation: 0,
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacingMd,
          vertical: AppSizes.spacingXs,
        ),
        minVerticalPadding: AppSizes.spacingXs,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusDefault),
        ),
        titleTextStyle: AppTypography.bodyText,
        subtitleTextStyle: AppTypography.secondaryLabel,
        leadingAndTrailingTextStyle: AppTypography.secondaryLabel,
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.primaryLightest,
        circularTrackColor: AppColors.primaryLightest,
      ),

      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.primaryLightest,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withValues(alpha: 0.12),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.white;
          }
          return AppColors.textMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.surfaceLight;
        }),
      ),

      // Tab Bar Theme
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTypography.buttonTextSmall.copyWith(
          color: AppColors.primary,
        ),
        unselectedLabelStyle: AppTypography.buttonTextSmall.copyWith(
          color: AppColors.textSecondary,
        ),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),

      // Tooltip Theme
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.textPrimary,
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
        textStyle: AppTypography.secondaryLabel.copyWith(
          color: AppColors.white,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacingSm,
          vertical: AppSizes.spacingXs,
        ),
      ),
    );
  }

  /// Build custom text theme using system font
  /// Replaced GoogleFonts.inter with system fonts for offline-first operation
  TextTheme _buildTextTheme() {
    // Use AppTypography.textTheme which uses system fonts (no Google Fonts dependency)
    // This ensures the app works completely offline without network font downloads
    return AppTypography.textTheme;
  }
}
