import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PromoBannerView extends StatelessWidget {
  const PromoBannerView({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: context.dimens.contentPadding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colors.promoGradientStart,
            context.colors.promoGradientEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(context.dimens.radiusLarge),
      ),
      child: Text(
        text,
        style: context.typography.titleMedium
            .copyWith(color: context.colors.onBrandPrimary),
      ),
    );
  }
}
