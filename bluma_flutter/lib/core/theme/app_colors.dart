import 'package:flutter/material.dart';

class AppColors {
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color surfaceVariant2;
  final Color surfaceTabBar;
  final Color panel;
  final Color border;

  final Color primary;
  final Color primaryLight;
  final Color accentPink;
  final Color accentPinkLight;
  final Color accentBlue;

  final Color predictionCircleBackground;
  final Color predictionCirclePeriodBackground;
  final Color predictionCircleOuter;
  final Color predictionCirclePeriodOuter;
  final Color insightCardBorder;
  final Color insightCardBackground;

  final Color icon;
  final Color backgroundIcon;

  final Color shape1;
  final Color shape2;

  final Color neutral100;
  final Color neutral150;
  final Color neutral200;
  final Color neutral300;
  final Color neutral400;

  final Color textPrimary;
  final Color textSecondary;
  final Color placeholder;

  final Color success;
  final Color warning;
  final Color warningLight;
  final Color error;
  final Color info;

  final Color white;
  final Color black;

  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.surfaceVariant2,
    required this.surfaceTabBar,
    required this.panel,
    required this.border,
    required this.primary,
    required this.primaryLight,
    required this.accentPink,
    required this.accentPinkLight,
    required this.accentBlue,
    required this.predictionCircleBackground,
    required this.predictionCirclePeriodBackground,
    required this.predictionCircleOuter,
    required this.predictionCirclePeriodOuter,
    required this.insightCardBorder,
    required this.insightCardBackground,
    required this.icon,
    required this.backgroundIcon,
    required this.shape1,
    required this.shape2,
    required this.neutral100,
    required this.neutral150,
    required this.neutral200,
    required this.neutral300,
    required this.neutral400,
    required this.textPrimary,
    required this.textSecondary,
    required this.placeholder,
    required this.success,
    required this.warning,
    required this.warningLight,
    required this.error,
    required this.info,
    required this.white,
    required this.black,
  });

  static const light = AppColors(
    background: Color(0xFFECEDFF),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFF0F1FF),
    surfaceVariant2: Color(0xFFFFFFFF),
    surfaceTabBar: Color(0xFFF1F0F6),
    panel: Color(0xFFFFFFFF),
    border: Color(0xFFEFEFF6),
    primary: Color(0xFF4B61C7),
    primaryLight: Color(0xFFD6E8FE),
    accentPink: Color(0xFFFB3192),
    accentPinkLight: Color(0xFFFFE8F3),
    accentBlue: Color(0xFF4B61C7),
    predictionCircleBackground: Color(0xFFFFFFFF),
    predictionCirclePeriodBackground: Color(0xFFFFE4F2),
    predictionCirclePeriodOuter: Color(0xFFFE6E97),
    predictionCircleOuter: Color(0xFFCDCFEA),
    insightCardBorder: Color(0xFF475FC3),
    insightCardBackground: Color(0xFFDEE4FC),
    icon: Color(0xFF1A1A28),
    backgroundIcon: Color(0xFFFFFFFF),
    shape1: Color(0xFFE8ECFF),
    shape2: Color(0xFFFFEBF6),
    neutral100: Color(0xFFDADAE4),
    neutral150: Color(0xFFE3E4F3),
    neutral200: Color(0xFF8A86A9),
    neutral300: Color(0xFFD8DAFF),
    neutral400: Color(0xFF706D8C),
    textPrimary: Color(0xFF25253F),
    textSecondary: Color(0xFF585470),
    placeholder: Color(0xFF8D8A99),
    success: Color(0xFF10B981),
    warning: Color(0xFFF59E0B),
    warningLight: Color(0xFFFEF3C7),
    error: Color(0xFFEF4444),
    info: Color(0xFF3B82F6),
    white: Color(0xFFFFFFFF),
    black: Color(0xFF000000),
  );

  static const dark = AppColors(
    background: Color(0xFF000219),
    surface: Color(0xFF1A1C31),
    surfaceVariant: Color(0xFF26253E),
    surfaceVariant2: Color(0xFF30304D),
    surfaceTabBar: Color(0xFF22213F),
    panel: Color(0xFF0E0D23),
    border: Color(0xFF26253F),
    primary: Color(0xFF5F7AF4),
    primaryLight: Color(0xFF26253E),
    accentPink: Color(0xFFFF4DA6),
    accentPinkLight: Color(0xFFFFDEEE),
    accentBlue: Color(0xFF75AAFF),
    predictionCircleBackground: Color(0xFF1C1B33),
    predictionCirclePeriodBackground: Color(0xFFFFC3E0),
    predictionCirclePeriodOuter: Color(0xFFFF9BC8),
    predictionCircleOuter: Color(0xFF26253E),
    insightCardBorder: Color(0xFF47465F),
    insightCardBackground: Color(0xFF26253E),
    icon: Color(0xFFD4D4F6),
    backgroundIcon: Color(0xFF302F4C),
    shape1: Color(0xFF28263D),
    shape2: Color(0xFF28263D),
    neutral100: Color(0xFF5E5D7F),
    neutral150: Color(0xFF3E3D5C),
    neutral200: Color(0xFF696981),
    neutral300: Color(0xFF26253E),
    neutral400: Color(0xFF706D8C),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFD7D7E3),
    placeholder: Color(0xFFA5A4C2),
    success: Color(0xFF34D399),
    warning: Color(0xFFFBBF24),
    warningLight: Color(0xFF422006),
    error: Color(0xFFF87171),
    info: Color(0xFF60A5FA),
    white: Color(0xFFFFFFFF),
    black: Color(0xFF000000),
  );
}

extension AppColorsExtension on BuildContext {
  AppColors get colors => Theme.of(this).brightness == Brightness.light
      ? AppColors.light
      : AppColors.dark;
}
