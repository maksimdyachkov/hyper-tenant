import '../models/payment_summary.dart';

abstract interface class PaymentRepository {
  Future<PaymentSummary> getSummary();
}
