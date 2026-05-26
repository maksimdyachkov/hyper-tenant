import 'package:flutter/material.dart';

/// Brand-specific *semantic* colours not covered by [ColorScheme].
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.brandPrimary,
    required this.onBrandPrimary,
    required this.brandSecondary,
    required this.surface,
    required this.onSurface,
    required this.surfaceElevated,
    required this.success,
    required this.warning,
    required this.danger,
    required this.promoGradientStart,
    required this.promoGradientEnd,
  });

  final Color brandPrimary;
  final Color onBrandPrimary;
  final Color brandSecondary;
  final Color surface;
  final Color onSurface;
  final Color surfaceElevated;
  final Color success;
  final Color warning;
  final Color danger;
  final Color promoGradientStart;
  final Color promoGradientEnd;

  @override
  AppColors copyWith({
    Color? brandPrimary,
    Color? onBrandPrimary,
    Color? brandSecondary,
    Color? surface,
    Color? onSurface,
    Color? surfaceElevated,
    Color? success,
    Color? warning,
    Color? danger,
    Color? promoGradientStart,
    Color? promoGradientEnd,
  }) {
    return AppColors(
      brandPrimary: brandPrimary ?? this.brandPrimary,
      onBrandPrimary: onBrandPrimary ?? this.onBrandPrimary,
      brandSecondary: brandSecondary ?? this.brandSecondary,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      promoGradientStart: promoGradientStart ?? this.promoGradientStart,
      promoGradientEnd: promoGradientEnd ?? this.promoGradientEnd,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      onBrandPrimary: Color.lerp(onBrandPrimary, other.onBrandPrimary, t)!,
      brandSecondary: Color.lerp(brandSecondary, other.brandSecondary, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      promoGradientStart:
          Color.lerp(promoGradientStart, other.promoGradientStart, t)!,
      promoGradientEnd:
          Color.lerp(promoGradientEnd, other.promoGradientEnd, t)!,
    );
  }
}
