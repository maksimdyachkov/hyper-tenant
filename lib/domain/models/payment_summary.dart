import 'package:equatable/equatable.dart';

class PaymentSummary extends Equatable {
  final double amountDue;
  final String currency;

  const PaymentSummary({
    required this.amountDue,
    required this.currency,
  });

  @override
  List<Object?> get props => [amountDue, currency];
}
