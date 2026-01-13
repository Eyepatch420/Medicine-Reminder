import 'package:flutter/material.dart';

class TimePickerButton extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final VoidCallback onPickTime;

  const TimePickerButton({
    super.key,
    required this.selectedTime,
    required this.onPickTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reminder Time',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: onPickTime,
          icon: const Icon(Icons.access_time),
          label: Text(
            selectedTime == null
                ? 'Select Time'
                : selectedTime!.format(context),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            alignment: Alignment.centerLeft,
          ),
        ),
      ],
    );
  }
}
