import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/notification_service.dart';

class TestHomeScreen extends ConsumerWidget {
  const TestHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Notifications'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Scheduled Test (10s) - replaced by immediate notification
            ElevatedButton(
              onPressed: () async {
                await NotificationService.showImmediate(
                    'Scheduled Test', 'This would have been a scheduled test.');
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Triggered immediate test notification')),
                );
              },
              child: const Text('Schedule Test (+10s)'),
            ),
            const SizedBox(height: 20),

            // Immediate Foreground Test
            ElevatedButton(
              onPressed: () async {
                // showImmediateTest no longer exists; use showImmediate instead
                await NotificationService.showImmediate('Foreground Test', 'Foreground test fired');

                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Foreground Test Fired!'),
                  ),
                );
              },
              child: const Text('Foreground Test (Instant)'),
            ),
          ],
        ),
      ),
    );
  }
}
