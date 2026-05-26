abstract interface class PaymentProcessingService {
  Future<bool> ensureNotificationPermission();
  Future<void> start();
  Future<void> stop();
}