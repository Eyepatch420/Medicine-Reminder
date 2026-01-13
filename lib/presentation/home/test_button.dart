import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/notification_service.dart';

class TestButton extends ConsumerWidget {
  const TestButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        // scheduleExactTest no longer exists; use immediate test notification instead
        await NotificationService.showImmediate('Test Notification', 'This is a test (instant)');
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sent immediate test notification')),
        );
      },
      child: const Text('TEST 10s NOTIFICATION'),
    );
  }
}
