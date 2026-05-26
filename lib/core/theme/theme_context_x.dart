import 'package:flutter/material.dart';

import 'extensions/app_colors.dart';
import 'extensions/app_dimens.dart';
import 'extensions/app_typography.dart';

/// The single place the app touches `Theme.of(context).extension<T>()!`.
/// Throws loudly if an extension is missing from ThemeData (programmer error).
extension ThemeContextX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
  AppDimens get dimens => Theme.of(this).extension<AppDimens>()!;
  AppTypography get typography => Theme.of(this).extension<AppTypography>()!;
}
