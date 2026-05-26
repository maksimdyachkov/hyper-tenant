import 'dart:ui' show FontFeature;
import 'package:flutter/material.dart';

/// Brand-specific type scale.
@immutable
class AppTypography extends ThemeExtension<AppTypography> {
  const AppTypography({
    required this.displayLarge,
    required this.headlineMedium,
    required this.titleMedium,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.labelLarge,
    required this.amountMono,
  });

  final TextStyle displayLarge;
  final TextStyle headlineMedium;
  final TextStyle titleMedium;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle labelLarge;
  final TextStyle amountMono;

  static const AppTypography retail = AppTypography(
    displayLarge: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        height: 1.1,
        letterSpacing: -0.5),
    headlineMedium:
        TextStyle(fontSize: 24, fontWeight: FontWeight.w700, height: 1.2),
    titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, height: 1.4),
    bodyMedium:
        TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.4),
    labelLarge:
        TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.3),
    amountMono: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFeatures: [FontFeature.tabularFigures()]),
  );

  static const AppTypography utility = AppTypography(
    displayLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.05,
        letterSpacing: -0.2),
    headlineMedium:
        TextStyle(fontSize: 20, fontWeight: FontWeight.w700, height: 1.1),
    titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    bodyLarge:
        TextStyle(fontSize: 18, fontWeight: FontWeight.w400, height: 1.25),
    bodyMedium:
        TextStyle(fontSize: 13, fontWeight: FontWeight.w400, height: 1.25),
    labelLarge:
        TextStyle(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.2),
    amountMono: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        fontFeatures: [FontFeature.tabularFigures()]),
  );

  @override
  AppTypography copyWith({
    TextStyle? displayLarge,
    TextStyle? headlineMedium,
    TextStyle? titleMedium,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? labelLarge,
    TextStyle? amountMono,
  }) {
    return AppTypography(
      displayLarge: displayLarge ?? this.displayLarge,
      headlineMedium: headlineMedium ?? this.headlineMedium,
      titleMedium: titleMedium ?? this.titleMedium,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      labelLarge: labelLarge ?? this.labelLarge,
      amountMono: amountMono ?? this.amountMono,
    );
  }

  @override
  AppTypography lerp(ThemeExtension<AppTypography>? other, double t) {
    if (other is! AppTypography) return this;
    return AppTypography(
      displayLarge: TextStyle.lerp(displayLarge, other.displayLarge, t)!,
      headlineMedium: TextStyle.lerp(headlineMedium, other.headlineMedium, t)!,
      titleMedium: TextStyle.lerp(titleMedium, other.titleMedium, t)!,
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t)!,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t)!,
      labelLarge: TextStyle.lerp(labelLarge, other.labelLarge, t)!,
      amountMono: TextStyle.lerp(amountMono, other.amountMono, t)!,
    );
  }
}
