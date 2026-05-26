import '../../domain/models/payment_summary.dart';
import '../../domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  PaymentRepositoryImpl({required this.loadAssets});

  final String loadAssets;

  @override
  Future<PaymentSummary> getSummary() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const PaymentSummary(amountDue: 120.50, currency: '\$');
  }
}
