import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

Future<void> showRootWarningDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AlertDialog(
      title: Text(
        'Security warning',
        style: context.typography.displayLarge,
      ),
      content: Text(
        'Security check failed. For your safety, '
        'some features may be limited.',
        style: context.typography.bodyLarge.copyWith(color: context.colors.danger),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
