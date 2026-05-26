import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../domain/models/layout_block.dart';
import '../widgets/amount_due_view.dart';
import '../widgets/bill_breakdown_view.dart';
import '../widgets/pay_button_view.dart';
import '../widgets/promo_banner_view.dart';
import 'payment_section.dart';

class AmountDueSection implements PaymentSection {
  const AmountDueSection();

  @override
  String get type => 'amount_due';

  @override
  Widget build(BuildContext context, LayoutBlock block) =>
      const AmountDueView();
}

class PromoBannerSection implements PaymentSection {
  const PromoBannerSection();

  @override
  String get type => 'promo_banner';

  @override
  Widget build(BuildContext context, LayoutBlock block) {
    final data = PromoBannerData.fromJson(block.data);
    return PromoBannerView(text: data.text);
  }
}

class BillBreakdownSection implements PaymentSection {
  const BillBreakdownSection();

  @override
  String get type => 'bill_breakdown';

  @override
  Widget build(BuildContext context, LayoutBlock block) {
    final data = BillBreakdownData.fromJson(block.data);
    final items = data.items
        .map((e) => BillItem(label: e.label, amount: e.amount))
        .toList();
    return BillBreakdownView(items: items);
  }
}

class PayButtonSection implements PaymentSection {
  const PayButtonSection();

  @override
  String get type => 'pay_button';

  @override
  Widget build(BuildContext context, LayoutBlock block) =>
      const PayButtonView();
}

class UnknownSection implements PaymentSection {
  const UnknownSection();

  @override
  String get type => 'unknown';

  @override
  Widget build(BuildContext context, LayoutBlock block) =>
      const SizedBox.shrink();
}
