import 'package:flutter/material.dart';

import 'extensions/app_colors.dart';
import 'extensions/app_dimens.dart';
import 'extensions/app_typography.dart';
import 'page_transitions.dart';

// Barrel: a single `import '../../core/theme/app_theme.dart'` exposes both the
// AppTheme factories AND the `context.colors / dimens / typography` sugar, so
// the section widgets only need one import.
export 'theme_context_x.dart';
export 'extensions/app_colors.dart';
export 'extensions/app_dimens.dart';
export 'extensions/app_typography.dart';

/// Builds the brand [ThemeData], wiring the custom ThemeExtensions into the
/// `extensions:` array alongside a Material 3 [ColorScheme].
abstract final class AppTheme {
  const AppTheme._();

  // ===== RETAIL SHOP - warm, rounded, fluid =============================
  static ThemeData retailShop() {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFF57C00),
      brightness: Brightness.light,
    );

    const colors = AppColors(
      brandPrimary: Color(0xFFF57C00),
      onBrandPrimary: Color(0xFFFFFFFF),
      brandSecondary: Color(0xFFFFB300),
      surface: Color(0xFFFFFDFB),
      onSurface: Color(0xFF1A1A1A),
      surfaceElevated: Color(0xFFFFF8F0),
      success: Color(0xFF2E7D32),
      warning: Color(0xFFF9A825),
      danger: Color(0xFFC62828),
      promoGradientStart: Color(0xFFFF8A00),
      promoGradientEnd: Color(0xFFFFC371),
    );

    const dimens = AppDimens(
      radiusSmall: 12,
      radiusMedium: 16,
      radiusLarge: 24,
      borderWidth: 0,
      spacingUnit: 8,
      cardElevation: 2,
      sizeSecurityScanView: 220,
      buttonShape: StadiumBorder(),
      cardShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      contentPadding: EdgeInsets.all(20),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: colors.surface,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      extensions: const <ThemeExtension<dynamic>>[
        colors,
        dimens,
        AppTypography.retail,
      ],
    );
  }

  // ===== UTILITY PAY - professional, sharp, dense =======================
  static ThemeData utilityPay() {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1E3A5F),
      brightness: Brightness.light,
    );

    const colors = AppColors(
      brandPrimary: Color(0xFF1E3A5F),
      onBrandPrimary: Color(0xFFFFFFFF),
      brandSecondary: Color(0xFF475569),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF0F172A),
      surfaceElevated: Color(0xFFF1F5F9),
      success: Color(0xFF15803D),
      warning: Color(0xFFB45309),
      danger: Color(0xFFB91C1C),
      promoGradientStart: Color(0xFF1E3A5F),
      promoGradientEnd: Color(0xFF334155),
    );

    const dimens = AppDimens(
      radiusSmall: 0,
      radiusMedium: 2,
      radiusLarge: 4,
      borderWidth: 1,
      spacingUnit: 4,
      cardElevation: 0,
      sizeSecurityScanView: 220,
      buttonShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
      cardShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      contentPadding: EdgeInsets.all(12),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: colors.surface,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: SharpPageTransitionsBuilder(),
          TargetPlatform.iOS: SharpPageTransitionsBuilder(),
        },
      ),
      extensions: const <ThemeExtension<dynamic>>[
        colors,
        dimens,
        AppTypography.utility,
      ],
    );
  }
}
