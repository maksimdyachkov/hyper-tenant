import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/error/failure.dart';
import '../../domain/repositories/layout_repository.dart';
import '../../domain/repositories/payment_repository.dart';
import 'payment_content_state.dart';

/// Loads the payment screen content (summary + SDUI layout).
/// One responsibility: screen content. Knows nothing about the checkout flow.
class PaymentContentCubit extends Cubit<PaymentContentState> {
  PaymentContentCubit({
    required PaymentRepository paymentRepo,
    required LayoutRepository layoutRepo,
  })  : _paymentRepo = paymentRepo,
        _layoutRepo = layoutRepo,
        super(const PaymentContentState());

  final PaymentRepository _paymentRepo;
  final LayoutRepository _layoutRepo;

  Future<void> load() async {
    emit(const PaymentContentState(status: ContentStatus.loading));
    try {
      final summaryFuture = _paymentRepo.getSummary();
      final layoutFuture = _layoutRepo.getPaymentScreenLayout();
      final summary = await summaryFuture;
      final layout = await layoutFuture;
      emit(PaymentContentState(
        status: ContentStatus.success,
        summary: summary,
        layout: layout,
      ));
    } on PaymentFailure catch (f) {
      emit(PaymentContentState(status: ContentStatus.failure, failure: f));
    } catch (_) {
      emit(const PaymentContentState(
          status: ContentStatus.failure, failure: UnknownFailure()));
    }
  }
}
