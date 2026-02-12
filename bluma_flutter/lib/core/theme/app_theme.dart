import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final colors = AppColors.light;
    return _buildTheme(colors, Brightness.light);
  }

  static ThemeData get darkTheme {
    final colors = AppColors.dark;
    return _buildTheme(colors, Brightness.dark);
  }

  static ThemeData _buildTheme(AppColors colors, Brightness brightness) {
    final baseTextTheme = GoogleFonts.bricolageGrotesqueTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: colors.background,
      primaryColor: colors.primary,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.primary,
        onPrimary: colors.white,
        secondary: colors.accentPink,
        onSecondary: colors.white,
        error: colors.error,
        onError: colors.white,
        background: colors.background,
        onBackground: colors.textPrimary,
        surface: colors.surface,
        onSurface: colors.textPrimary,
        surfaceVariant: colors.surfaceVariant,
        onSurfaceVariant: colors.textSecondary,
        outline: colors.border,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: colors.textPrimary,
        ),
        displayMedium: baseTextTheme.displayMedium?.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: colors.textPrimary,
        ),
        displaySmall: baseTextTheme.displaySmall?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: colors.textPrimary,
        ),
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: colors.textPrimary,
        ),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
        headlineSmall: baseTextTheme.headlineSmall?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          fontSize: 17,
          lineHeight: 23 / 17,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.3,
          color: colors.textPrimary,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          fontSize: 16,
          lineHeight: 22 / 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          color: colors.textPrimary,
        ),
        bodySmall: baseTextTheme.bodySmall?.copyWith(
          fontSize: 14,
          lineHeight: 18 / 14,
          fontWeight: FontWeight.w400,
          color: colors.textSecondary,
        ),
        labelLarge: baseTextTheme.labelLarge?.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: colors.textPrimary,
        ),
        labelMedium: baseTextTheme.labelMedium?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: colors.textPrimary,
        ),
        labelSmall: baseTextTheme.labelSmall?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: colors.textPrimary,
        ),
      ),
    );
  }
}

extension TypographyExtension on TextTheme {
  TextStyle get bodyBold => bodyMedium!.copyWith(fontWeight: FontWeight.w600);
  TextStyle get bodyXl => bodyMedium!.copyWith(
        fontSize: 18,
        lineHeight: 24 / 18,
        letterSpacing: 0.35,
      );
  TextStyle get captionBold => bodySmall!.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.light.textPrimary, // Note: this might need adjustment for dynamic theme
      );
  TextStyle get labelXs => bodySmall!.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w500,
      );
}
