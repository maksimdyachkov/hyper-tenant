import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../domain/services/security_service.dart';

const _isRooted = 'isRooted';
const _enableSecure = 'enableSecure';
const _disableSecure = 'disableSecure';

class SecurityServiceImpl implements SecurityService {
  SecurityServiceImpl({
    MethodChannel? channel,
    EventChannel? screenRecordingEvents,
  })  : _channel = channel ?? const MethodChannel('com.hypertenant/security'),
        _screenRecordingEvents = screenRecordingEvents ??
            const EventChannel('com.hypertenant/screen_recording');

  final MethodChannel _channel;
  final EventChannel _screenRecordingEvents;

  @override
  Future<bool> isDeviceRooted() async {
    // TODO:(Max) Implement Play Integrity Check for real production App
    try {
      return await _channel.invokeMethod<bool>(_isRooted) ?? false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> enableSecureWindow() => _invokeVoid(_enableSecure);

  @override
  Future<void> disableSecureWindow() => _invokeVoid(_disableSecure);

  @override
  Stream<bool> screenRecordingState() {
    return _screenRecordingEvents
        .receiveBroadcastStream()
        .map((event) => event == true)
        .handleError((_) {});
  }

  Future<void> _invokeVoid(String method) async {
    try {
      await _channel.invokeMethod<void>(method);
    } catch (e) {
      debugPrint('$method failed: $e');
    }
  }
}
