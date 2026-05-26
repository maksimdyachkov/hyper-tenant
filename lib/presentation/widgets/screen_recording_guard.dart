import 'package:flutter/material.dart';

import '../../domain/services/security_service.dart';
import '../../injection_container.dart';
import '../../core/theme/app_theme.dart';

/// Obscures its [child] while the screen is being recorded (Android 15+).
/// FLAG_SECURE already blocks the capture itself; this adds a visible,
/// in-app reaction so the user knows recording is active.
class ScreenRecordingGuard extends StatefulWidget {
  const ScreenRecordingGuard({super.key, required this.child});

  final Widget child;

  @override
  State<ScreenRecordingGuard> createState() => _ScreenRecordingGuardState();
}

class _ScreenRecordingGuardState extends State<ScreenRecordingGuard> {
  late final Stream<bool> _recording =
      sl<SecurityService>().screenRecordingState();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _recording,
      initialData: false,
      builder: (context, snapshot) {
        final recording = snapshot.data ?? false;
        return Stack(
          children: [
            widget.child,
            if (recording) const _RecordingBlocker(),
          ],
        );
      },
    );
  }
}

class _RecordingBlocker extends StatelessWidget {
  const _RecordingBlocker();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AbsorbPointer(
        child: ColoredBox(
          color: Colors.black,
          child: Material(
            type: MaterialType.transparency,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.screen_share_outlined,
                      color: context.colors.onBrandPrimary, size: 48),
                   SizedBox(height: context.dimens.space(2)),
                  Text(
                    'Screen recording detected.\n'
                    'Payment is hidden for your safety.',
                    textAlign: TextAlign.center,
                    style: context.typography.bodyLarge.copyWith(
                      color: context.colors.onBrandPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
