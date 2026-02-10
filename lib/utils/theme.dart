import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color accent = Color(0xFF6366F1);
  
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color surfaceElevated = Colors.white;
  
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  
  static const Color divider = Color(0xFFE2E8F0);
  static const Color border = Color(0xFFF1F5F9);
  
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
}

class AppDimens {
  static const double borderRadiusSm = 8.0;
  static const double borderRadiusMd = 12.0;
  static const double borderRadiusLg = 16.0;
  static const double borderRadiusXl = 24.0;
  static const double borderRadiusFull = 999.0;
  
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;
  
  static const double iconSizeSm = 20.0;
  static const double iconSizeMd = 24.0;
  static const double iconSizeLg = 28.0;
}

class AppShadows {
  static const List<BoxShadow> soft = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];
  
  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];
}

ThemeData get appTheme {
  return ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.surface,
      error: AppColors.error,
    ),
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.borderRadiusLg),
        side: const BorderSide(color: AppColors.divider, width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.borderRadiusMd),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spacingLg,
          vertical: AppDimens.spacingMd,
        ),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.borderRadiusMd),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spacingLg,
          vertical: AppDimens.spacingMd,
        ),
        side: const BorderSide(color: AppColors.divider),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.borderRadiusMd),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.borderRadiusMd),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.borderRadiusMd),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spacingMd,
        vertical: AppDimens.spacingMd,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      elevation: 0,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textTertiary,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      elevation: 0,
      indicatorColor: AppColors.primary.withValues(alpha: 0.1),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.textSecondary,
      size: AppDimens.iconSizeMd,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.textTertiary,
      ),
    ),
  );
}
