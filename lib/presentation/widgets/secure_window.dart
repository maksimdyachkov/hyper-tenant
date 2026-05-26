import 'package:flutter/widgets.dart';
import '../../domain/services/security_service.dart';
import '../../injection_container.dart';

class SecureWindow extends StatefulWidget {
  const SecureWindow({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<SecureWindow> createState() => _SecureWindowState();
}

class _SecureWindowState extends State<SecureWindow> {
  final SecurityService _security = sl<SecurityService>();

  @override
  void initState() {
    super.initState();
    _security.enableSecureWindow();
  }

  @override
  void dispose() {
    _security.disableSecureWindow();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
