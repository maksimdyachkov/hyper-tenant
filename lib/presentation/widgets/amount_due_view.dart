import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/models/payment_summary.dart';
import '../cubit/payment_content_cubit.dart';
import '../cubit/payment_content_state.dart';

class AmountDueView extends StatelessWidget {
  const AmountDueView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PaymentContentCubit, PaymentContentState,
        PaymentSummary?>(
      selector: (state) => state.summary,
      builder: (context, summary) {
        if (summary == null) return const SizedBox.shrink();
        final amount = NumberFormat.currency(
          symbol: summary.currency,
          decimalDigits: 2,
        ).format(summary.amountDue);
        return Container(
          width: double.infinity,
          padding: context.dimens.contentPadding,
          color: context.colors.surfaceElevated,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Amount due', style: context.typography.bodyMedium),
              Text(
                amount,
                style: context.typography.displayLarge
                    .copyWith(color: context.colors.brandPrimary),
              ),
            ],
          ),
        );
      },
    );
  }
}
