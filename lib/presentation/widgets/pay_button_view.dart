import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../cubit/checkout_cubit.dart';

class PayButtonView extends StatelessWidget {
  const PayButtonView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutPhase>(
      builder: (context, phase) {
        final busy = phase == CheckoutPhase.scanning ||
            phase == CheckoutPhase.processing;
        return SizedBox(
          width: double.infinity,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: context.colors.brandPrimary,
              foregroundColor: context.colors.onBrandPrimary,
              shape: context.dimens.buttonShape,
              padding: EdgeInsets.symmetric(vertical: context.dimens.space(2)),
            ),
            // Disabled while a checkout is running -> no double taps.
            onPressed:
                busy ? null : () => context.read<CheckoutCubit>().start(),
            child: const Text('Pay Now'),
          ),
        );
      },
    );
  }
}
