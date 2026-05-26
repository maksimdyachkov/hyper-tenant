import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

/// Brand-specific shape, radius, spacing and density tokens.
@immutable
class AppDimens extends ThemeExtension<AppDimens> {
  const AppDimens({
    required this.radiusSmall,
    required this.radiusMedium,
    required this.radiusLarge,
    required this.borderWidth,
    required this.spacingUnit,
    required this.cardElevation,
    required this.buttonShape,
    required this.cardShape,
    required this.contentPadding,
    required this.sizeSecurityScanView,
  });

  final double radiusSmall;
  final double radiusMedium;
  final double radiusLarge;
  final double borderWidth;
  final double spacingUnit;
  final double cardElevation;
  final OutlinedBorder buttonShape;
  final OutlinedBorder cardShape;
  final EdgeInsets contentPadding;
  final double sizeSecurityScanView;

  double space(double multiplier) => spacingUnit * multiplier;

  @override
  AppDimens copyWith({
    double? radiusSmall,
    double? radiusMedium,
    double? radiusLarge,
    double? borderWidth,
    double? spacingUnit,
    double? cardElevation,
    double? sizeSecurityScanView,
    OutlinedBorder? buttonShape,
    OutlinedBorder? cardShape,
    EdgeInsets? contentPadding,
  }) {
    return AppDimens(
      radiusSmall: radiusSmall ?? this.radiusSmall,
      radiusMedium: radiusMedium ?? this.radiusMedium,
      radiusLarge: radiusLarge ?? this.radiusLarge,
      borderWidth: borderWidth ?? this.borderWidth,
      spacingUnit: spacingUnit ?? this.spacingUnit,
      cardElevation: cardElevation ?? this.cardElevation,
      sizeSecurityScanView: sizeSecurityScanView ?? this.sizeSecurityScanView,
      buttonShape: buttonShape ?? this.buttonShape,
      cardShape: cardShape ?? this.cardShape,
      contentPadding: contentPadding ?? this.contentPadding,
    );
  }

  @override
  AppDimens lerp(ThemeExtension<AppDimens>? other, double t) {
    if (other is! AppDimens) return this;
    return AppDimens(
      radiusSmall: lerpDouble(radiusSmall, other.radiusSmall, t)!,
      radiusMedium: lerpDouble(radiusMedium, other.radiusMedium, t)!,
      radiusLarge: lerpDouble(radiusLarge, other.radiusLarge, t)!,
      borderWidth: lerpDouble(borderWidth, other.borderWidth, t)!,
      spacingUnit: lerpDouble(spacingUnit, other.spacingUnit, t)!,
      cardElevation: lerpDouble(cardElevation, other.cardElevation, t)!,
      sizeSecurityScanView: lerpDouble(sizeSecurityScanView, other.sizeSecurityScanView, t)!,
      buttonShape:
          ShapeBorder.lerp(buttonShape, other.buttonShape, t) as OutlinedBorder? ??
              buttonShape,
      cardShape: ShapeBorder.lerp(cardShape, other.cardShape, t) as OutlinedBorder? ??
          cardShape,
      contentPadding: EdgeInsets.lerp(contentPadding, other.contentPadding, t)!,
    );
  }
}
