abstract interface class SecurityService {
  Future<bool> isDeviceRooted();

  Future<void> enableSecureWindow();

  Future<void> disableSecureWindow();

  /// Emits `true` while the screen is being recorded (Android 15+).
  /// On older versions / unsupported platforms it stays `false`.
  Stream<bool> screenRecordingState();
}
