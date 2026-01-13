import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onSave;

  const SaveButton({
    super.key,
    required this.isLoading,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onSave,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text('Save Medicine'),
    );
  }
}
