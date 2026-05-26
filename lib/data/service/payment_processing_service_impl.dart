import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../domain/services/payment_processing_service.dart';

const _start = 'start';
const _stop = 'stop';
const _requestNotificationPermission = 'requestNotificationPermission';

class PaymentProcessingServiceImpl implements PaymentProcessingService {
  PaymentProcessingServiceImpl({MethodChannel? channel})
      : _channel =
            channel ?? const MethodChannel('com.hypertenant/payment_service');

  final MethodChannel _channel;

  @override
  Future<bool> ensureNotificationPermission() async {
    try {
      return await _channel
              .invokeMethod<bool>(_requestNotificationPermission) ??
          false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> start() => _invoke(_start);

  @override
  Future<void> stop() => _invoke(_stop);

  Future<void> _invoke(String method) async {
    try {
      await _channel.invokeMethod<void>(method);
    } catch (e) {
      debugPrint('$method failed: $e');
    }
  }
}
