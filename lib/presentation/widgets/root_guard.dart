import 'package:flutter/material.dart';
import 'package:white_label_sdui/presentation/widgets/root_warning_dialog.dart';
import '../../domain/services/security_service.dart';
import '../../injection_container.dart';


class RootGuard extends StatefulWidget {
  const RootGuard({super.key, required this.child});
  final Widget child;

  @override
  State<RootGuard> createState() => _RootGuardState();
}

class _RootGuardState extends State<RootGuard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final rooted = await sl<SecurityService>().isDeviceRooted();
      debugPrint('isRooted $rooted');
      if (rooted && mounted) {
        showRootWarningDialog(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}