import 'package:flutter/material.dart';

class DosageTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const DosageTextField({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Dosage',
        hintText: 'e.g., 500mg or 2 tablets',
        prefixIcon: Icon(Icons.medical_information),
      ),
      validator: validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter dosage';
            }
            return null;
          },
    );
  }
}
