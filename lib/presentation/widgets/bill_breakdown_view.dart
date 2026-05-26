import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class BillItem {
  const BillItem({
    required this.label,
    required this.amount,
  });

  final String label;
  final double amount;
}

class BillBreakdownView extends StatelessWidget {
  const BillBreakdownView({super.key, required this.items});

  final List<BillItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: context.dimens.contentPadding,
      color: context.colors.surfaceElevated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bill breakdown', style: context.typography.titleMedium),
          SizedBox(height: context.dimens.space(1)),
          for (final item in items)
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: context.dimens.space(0.5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.label, style: context.typography.bodyMedium),
                  Text(
                    item.amount.toStringAsFixed(2),
                    style: context.typography.amountMono,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
