import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/services/payment_processing_service.dart';
import '../../domain/services/security_service.dart';

enum CheckoutPhase { idle, scanning, processing, blocked, done }

/// Orchestrates one checkout attempt: security scan -> payment processing.
/// The work is delegated to SecurityService and PaymentProcessingService;
/// this cubit only owns the flow/phase.
class CheckoutCubit extends Cubit<CheckoutPhase> {
  CheckoutCubit({
    required SecurityService security,
    required PaymentProcessingService processing,
  })  : _security = security,
        _processing = processing,
        super(CheckoutPhase.idle);

  final SecurityService _security;
  final PaymentProcessingService _processing;

  // Min time the scan stays visible; processing is a placeholder until EventChannel.
  static const _minScan = Duration(seconds: 3);

  // Approximate processing time (matches the native service ~13s).
// TODO:(Max) drive completion from the service via EventChannel instead of a timer.
  static const _processSim = Duration(seconds: 13);

  Future<void> start() async {
    if (state == CheckoutPhase.scanning || state == CheckoutPhase.processing) {
      return;
    }

    // Phase 1: security scan
    emit(CheckoutPhase.scanning);
    final minDelay = Future<void>.delayed(_minScan);
    final rooted = await _security.isDeviceRooted();
    await minDelay;
    if (rooted) {
      emit(CheckoutPhase.blocked);
      return;
    }

    // Phase 2: payment processing (foreground service)
    final granted = await _processing.ensureNotificationPermission();
    if (!granted) {
      emit(CheckoutPhase.idle);
      return;
    }
    emit(CheckoutPhase.processing);
    await _processing.start();

    await Future.delayed(_processSim);
    if (isClosed) return;
    emit(CheckoutPhase.done);
  }

  void reset() => emit(CheckoutPhase.idle);
}
