import 'package:flutter/foundation.dart';
import 'payment_section.dart';
import 'sections.dart';

/// Maps server block ids -> section factories. This is the SDUI factory,
/// extracted out of the screen so the screen never changes when widgets are
/// added (OCP). To integrate a new widget: add a Section + View, then ONE
/// entry here.
class SectionRegistry {
  const SectionRegistry();

  static const Map<String, PaymentSection> _registry = {
    'amount_due': AmountDueSection(),
    'promo_banner': PromoBannerSection(),
    'bill_breakdown': BillBreakdownSection(),
    'pay_button': PayButtonSection(),

  };

  /// Returns the section for [type], or a no-op for ids this app version does
  /// not know (graceful degradation + a debug-only warning so version skew is
  /// noticed during development).
  PaymentSection resolve(String type) {
    final section = _registry[type];
    if (section == null) {
      assert(() {
        debugPrint('SDUI: unknown section type "$type" — rendering nothing.');
        return true;
      }());
      return const UnknownSection();
    }
    return section;
  }
}
